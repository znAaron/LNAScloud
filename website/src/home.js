//model functions
//=====================
let rootDir;

let currDir = "files"
let currList;

let renderFolder = function(folder) {
    return `
        <tr class="file-row">
            <th scope="row">
                <input type="checkbox" aria-label="Checkbox for file">
            </th>
            <td>${folder.name}</td>
            <td>${folder.time}</td>
            <td></td>
        </tr>
    `
}

let renderFile = function(file) {
    return `
        <tr class="file-row">
            <th scope="row">
                <input type="checkbox" aria-label="Checkbox for file">
            </th>
            <td>one file</td>
            <td>July 1, 2020</td>
            <td>0 KB</td>
        </tr>
    `
}


let render = function() {
    $(".file-row").remove();
    if (rootDir.folders != null){
        $("#file-list").append(`${rootDir.folders.map(renderFolder).join('')}`);
    }
    if (rootDir.files != null){
        $("#file-list").append(`${rootDir.files.map(renderFile).join('')}`);
    }
}

let renderInfo = function(fileInfo){
    return `
        <tr class="file-row">
            <th scope="row">
                <input type="checkbox" aria-label="Checkbox for file">
            </th>
            <td>${fileInfo.Name}</td>
            <td>${fileInfo.ModTime}</td>
            <td>${fileInfo.size}</td>
        </tr>
    `
}

let renderInfos = function() {
    $(".file-row").remove();
    if (currList != null){
        $("#file-list").append(`${currList.map(renderFolder).join('')}`);
    }
}

$(document).ready(function() {
    /*$.getJSON('/rootDir',function(data) {
        rootDir = data;
        render();
    })*/
    $.getJSON('/dir',currDir,function(data) {
        currList = data;
        renderInfos();
    })

});