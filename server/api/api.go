package api

import (
	"fmt"
	"net/http"
	"os/exec"
	"strconv"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
	"github.com/igorrendulic/monitorcontrol/global"
	"github.com/igorrendulic/monitorcontrol/models"
)

type APIHandler struct {
}

func NewAPIHandler() *APIHandler {
	return &APIHandler{}
}

func (h *APIHandler) Ping(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"pong": "igorsmonitorcontrol_1234567"})
}

func (h *APIHandler) PingPong(c *gin.Context) {
	var data models.Ping
	if err := c.ShouldBindWith(&data, binding.JSON); err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
			"code":    http.StatusBadRequest,
			"message": "unrecognized request",
		})
		return
	}
	fmt.Printf("Received ping from %v\n", data.IP)
	c.JSON(http.StatusOK, data)
}

func (h *APIHandler) ListMonitors(c *gin.Context) {
	comm := &models.Command{
		Name:   "List monitors",
		Flag:   "d",
		Number: 0,
	}
	resp := executeCommand(comm, "1-1") // find up to 5 external monitors
	if resp.Code != http.StatusOK {
		c.JSON(resp.Code, resp)
		return
	}
	msg := resp.Message
	lines := strings.Split(msg, "\n")
	if len(lines) == 0 {
		c.JSON(http.StatusNotFound, resp)
		return
	}
	alreadyAdded := make(map[string]string)
	monitors := make([]*models.Monitor, 0)
	for i := 0; i < 5; i++ {
		monitor := &models.Monitor{}
		monitor.Screen = stripInfo(lines, "D: ", "")
		monitor.Name = stripInfo(lines, "edid.serial: ", "")
		monitor.Serial = stripInfo(lines, "edid.name: ", "")
		monitor.ID = stripInfo(lines, "polling display ", "'s EDI")
		if monitor.Screen == "" && monitor.Serial == "" && monitor.Name == "" {
			break
		}
		if _, ok := alreadyAdded[monitor.Serial]; !ok {
			monitors = append(monitors, monitor)
			alreadyAdded[monitor.Serial] = monitor.Name
		}
	}
	c.JSON(resp.Code, monitors)
}

func (h *APIHandler) Commands(c *gin.Context) {
	c.JSON(http.StatusOK, models.Commands)
}

func (h *APIHandler) Execute(c *gin.Context) {
	var data models.Command
	if err := c.ShouldBindWith(&data, binding.JSON); err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
			"code":    http.StatusBadRequest,
			"message": "unrecognized request",
		})
		return
	}

	if data.MonitorID == "" || data.Flag == "" && data.Number <= 0 {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
			"code":    http.StatusBadRequest,
			"message": "invalid command",
		})
		return
	}

	resp := executeCommand(&data, strconv.Itoa(data.Number))
	c.JSON(http.StatusOK, resp)
}

func executeCommand(comm *models.Command, modifiedFlag string) *models.CommandResponse {
	resp := &models.CommandResponse{}

	cmd := exec.Command(global.DDCCTLPath, "-d", comm.MonitorID, "-"+comm.Flag, modifiedFlag)
	out, err := cmd.Output()
	if err != nil {
		resp.Code = http.StatusExpectationFailed
		resp.Message = err.Error()
		return resp
	}
	resp.Code = http.StatusOK
	resp.Message = string(out)
	return resp
}

func stripInfo(lines []string, begin string, end string) string {
	for _, line := range lines {
		if strings.Contains(line, begin) {
			out := between(line, begin, end)
			return out
		}
	}
	return ""
}

func between(value string, a string, b string) string {
	// Get substring between two strings.
	posFirst := strings.Index(value, a)
	if posFirst == -1 {
		return ""
	}
	posEnd := len(value)
	if b != "" {
		posEnd = strings.Index(value, b)
	}
	posFirstAdjusted := posFirst + len(a)
	if posFirstAdjusted >= len(value) {
		return ""
	}
	return value[posFirstAdjusted:posEnd]
}
