package main

import (
	"flag"
	"fmt"
	"net/http"
	"os"
	"os/signal"

	"github.com/igorrendulic/monitorcontrol/api"
	"github.com/igorrendulic/monitorcontrol/global"
	"github.com/igorrendulic/monitorcontrol/server"
)

// DDCTLPath - path to ddcctl executable

func main() {

	ddcctlPath := flag.String("path", "", "path to ddcctl")
	flag.Parse()
	if *ddcctlPath == "" {
		flag.PrintDefaults()
		os.Exit(1)
	}

	global.DDCCTLPath = *ddcctlPath

	// server wait to shutdown monitoring channels
	done := make(chan bool, 1)
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, os.Interrupt)

	router := server.NewAPIRouter()

	apiHandler := api.NewAPIHandler()

	root := router.Group("/")
	{
		root.GET("/ping", apiHandler.Ping)
		root.POST("/ping", apiHandler.PingPong)
		root.GET("/monitors", apiHandler.ListMonitors)
		root.GET("/commands", apiHandler.Commands)
		root.POST("/commands", apiHandler.Execute)
	}

	srv := server.Start(router)
	// wait for server shutdown
	go server.Shutdown(srv, quit, done)

	fmt.Printf("Server is ready to handle requests at %d", 7800)
	if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
		fmt.Printf("Could not listen on %s: %v\n", "7800", err)
	}

	<-done
}
