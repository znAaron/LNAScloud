package nasfile

import (
	"fmt"
	"io/ioutil"
	"os"
	"time"

	"github.com/gin-gonic/gin"
)

//Folder represents a directory
type Folder struct {
	Name    string        `json:"name"`
	ModTime time.Time     `json:"time"`
	Files   []os.FileInfo `json:"files"`
	Folders []Folder      `json:"folders"`
}

//FileInfo represents simple info of a file or a folder
type fileInfo struct {
	Name    string    `json:"name"`
	ModTime time.Time `json:"time"`
	Size    int64     `json:"size"`
	IsDir   bool      `json:"isDir"`
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

type PathBody struct {
	Path string
}

//GetDir handles the folder info ger request
func GetDir(c *gin.Context) {
	/*body, _ := ioutil.ReadAll(c.Request.Body)
	fmt.Printf("%s\n", string(body))*/
	data := &PathBody{}
	c.Bind(data)
	fmt.Println(data)

	path := "./server/" + data.Path
	files, err := ioutil.ReadDir(path)

	fileInfos := []fileInfo{}
	for i := 0; i < len(files); i++ {
		newInfo := fileInfo{files[i].Name(), files[i].ModTime(), files[i].Size(), files[i].IsDir()}
		fileInfos = append(fileInfos, newInfo)
	}

	if err != nil {
		c.JSON(404, nil)
	} else {
		c.JSON(200, fileInfos)
	}
}
