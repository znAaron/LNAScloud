package server

import (
	"os"
	"time"
)

//Folder represents a directory
type Folder struct {
	name    string
	modTime time.Time
	files   []os.FileInfo
	folders []Folder
}

//InitiateRoot creates an empty root folder
func InitiateRoot() (rootDir *Folder) {
	rootDir.name = "user_root"
	rootDir.modTime = time.Now()
	return
}
