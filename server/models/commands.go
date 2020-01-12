package models

var (
	inputSource = []*Command{
		&Command{Name: "VGA 1", Flag: "i", Number: 1},
		&Command{Name: "VGA 2", Flag: "i", Number: 2},
		&Command{Name: "DVI 1", Flag: "i", Number: 3},
		&Command{Name: "DVI 2", Flag: "i", Number: 4},
		&Command{Name: "Composite Video 1", Flag: "i", Number: 5},
		&Command{Name: "Composite Video 2", Flag: "i", Number: 6},
		&Command{Name: "S-Video 1", Flag: "i", Number: 7},
		&Command{Name: "S-Video 2", Flag: "i", Number: 8},
		&Command{Name: "Display Port 1", Flag: "i", Number: 15},
		&Command{Name: "Display Port 2", Flag: "i", Number: 16},
		&Command{Name: "HDMI 1", Flag: "i", Number: 17},
		&Command{Name: "HDMI 2", Flag: "i", Number: 18},
	}

	monitorOn  = &Command{Name: "Monitor On", Flag: "p", Number: 1}
	monitorOff = &Command{Name: "Monitor Off", Flag: "p", Number: 5}

	muteSpeaker   = &Command{Name: "Speaker Mute", Flag: "m", Number: 2}
	enableSpeaker = &Command{Name: "Speaker Un-Mute", Flag: "m", Number: 1}

	speakerVolume = &Command{Name: "Speaker Volume", Flag: "v", Number: 254}

	Commands = &CommandList{
		InputSource:   inputSource,
		MonitorPower:  []*Command{monitorOn, monitorOff},
		SpeakerPower:  []*Command{muteSpeaker, enableSpeaker},
		SpeakerVolume: []*Command{speakerVolume},
	}
)

type Command struct {
	Name      string `json:"name"`
	Flag      string `json:"flag"`
	Number    int    `json:"number"`
	MonitorID string `json:"monitor_id"`
}

type CommandList struct {
	InputSource   []*Command `json:"input_source"`
	MonitorPower  []*Command `json:"monitor_power"`
	SpeakerPower  []*Command `json:"speaker_power"`
	SpeakerVolume []*Command `json:"speaker_volume"`
}

type CommandResponse struct {
	Code    int    `json:"code"`
	Message string `json:"message"`
}
