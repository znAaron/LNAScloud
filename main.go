package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
	nasfile "github.com/znAaron/LNAScloud/server"
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
	server.GET("/rootDir", getRoot)
	server.GET("/dir", nasfile.GetDir)
	//start the server
	server.Run(":8080")
}

//display the front page
func frontPage(c *gin.Context) {
	c.HTML(http.StatusOK, "index.html", gin.H{})
}

func getRoot(c *gin.Context) {
	rootDir := nasfile.InitiateRoot()
	c.JSON(200, rootDir)
}
