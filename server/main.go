package main

import (
	"fmt"
	"net/http"
	"os"
	"os/signal"
)

func main() {
	// server wait to shutdown monitoring channels
	done := make(chan bool, 1)
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, os.Interrupt)

	router := NewAPIRouter()

	apiHandler := NewAPIHandler()

	root := router.Group("/")
	{
		root.GET("/ping", apiHandler.Ping)
		root.POST("/ping", apiHandler.PingPong)
		root.GET("/monitors", apiHandler.ListMonitors)
		root.GET("/commands", apiHandler.Commands)
		root.POST("/commands", apiHandler.Execute)
	}

	srv := Start(router)
	// wait for server shutdown
	go Shutdown(srv, quit, done)

	fmt.Printf("Server is ready to handle requests at %d", 7800)
	if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
		fmt.Printf("Could not listen on %s: %v\n", "7800", err)
	}

	<-done
}
