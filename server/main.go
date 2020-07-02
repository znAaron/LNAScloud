package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {
	engine := gin.Default()
	engine.LoadHTMLGlob("./website/*.html")
	engine.Static("/src", "./website/src/")
	engine.Static("/style", "./website/style/")
	engine.Static("/pages", "./website/pages/")
	engine.GET("/", WebRoot)
	engine.Run(":8080")
}

func WebRoot(context *gin.Context) {
	context.HTML(http.StatusOK, "index.html", gin.H{})
}