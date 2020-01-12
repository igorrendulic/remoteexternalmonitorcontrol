package main

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func NewAPIRouter() *gin.Engine {
	// if conf.Mode == "release" {
	gin.SetMode(gin.ReleaseMode)
	// }

	router := gin.Default()

	router.Use(cors.New(cors.Config{
		AllowOrigins:     []string{"*"},
		AllowCredentials: true,
		AllowMethods:     []string{"PUT", "GET", "POST", "OPTIONS", "PATCH", "DELETE"},
		AllowHeaders:     []string{"cachepolicy", "content-type", "content-length", "origin", "authorization", "ngsw-bypass", " auth-mailio"},
		AllowWildcard:    true,
	}))

	// By default gin.DefaultWriter = os.Stdout
	// router.Use(gin.Logger())
	router.Use(gin.Recovery())

	return router
}

func Shutdown(server *http.Server, quit <-chan os.Signal, done chan<- bool) {
	<-quit

	// Wait for interrupt signal to gracefully shutdown the server with
	// a timeout of 30 seconds.
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	server.SetKeepAlivesEnabled(false)
	if err := server.Shutdown(ctx); err != nil {
		fmt.Printf("Could not gracefully shutdown the server: %v\n", err)
	}
	close(done)
}

func Start(router *gin.Engine) *http.Server {
	//  starting server (Default With the Logger and Recovery middleware already attached)

	srv := &http.Server{
		Addr:    fmt.Sprintf(":%d", 7800),
		Handler: router,
	}
	return srv
}
