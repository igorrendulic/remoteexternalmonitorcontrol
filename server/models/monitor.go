package models

type Monitor struct {
	Name   string `json:"name"`
	Screen string `json:"screen"`
	Serial string `json:"serial"`
	ID     string `json:"id"`
}

type Ping struct {
	IP string `json:"ip"`
}
