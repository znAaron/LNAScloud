//model functions
//=====================
let rootDir;

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
    $("#file-list").append(`${rootDir.folders.map(renderFolder).join('')}`);
    //$("#file-list").append(`${rootDir.files.map(renderFile).join('')}`);
}


$(document).ready(function() {
    sidetabHover();
    $.getJSON('rootDir',function(data) {
        rootDir = data;
        render();
    })
});