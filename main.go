package main

import (
	"net/http"
	"encoding/json"

	"github.com/gin-gonic/gin"
	"github.com/znAaron/LNAScloud/server"
)

func main() {
	//initiate the server
	server := gin.Default()
	//load the webpages
	server.LoadHTMLFiles("./website/index.html")
	server.Static("/src", "./website/src/")
	server.Static("/style", "./website/style/")
	server.Static("/pages", "./website/pages/")
	//load file system
	server.Static("/file", "./server/files")
	//handlers
	server.GET("/", frontPage)
	//start the server
	server.Run(":8080")
}

//display the front page
func frontPage(context *gin.Context) {
	context.HTML(http.StatusOK, "index.html", gin.H{})
}

func getRoot() {
	rootDir := server.InitiateRoot()
}
