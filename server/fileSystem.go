package server

import (
	"os"
	"time"
)

//Folder represents a directory
type Folder struct {
	Name    string        `json:"name"`
	ModTime time.Time     `json:"time"`
	Files   []os.FileInfo `json:"files"`
	Folders []Folder      `json:"folders"`
}

//InitiateRoot creates an empty root folder
func InitiateRoot() *Folder {
	subDir1 := Folder{"sub1", time.Now(), nil, nil}
	subDir2 := Folder{"sub2", time.Now(), nil, nil}
	sublist := []Folder{subDir1, subDir2}

	rootDir := Folder{}
	rootDir.Name = "user_root"
	rootDir.ModTime = time.Now()
	rootDir.Folders = sublist
	return &rootDir
}
