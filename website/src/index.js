//display functions
//========================
//system funcitons
let sidebarCollapseChange = function() {
    if (document.body.clientWidth < 576) {
        $("#side-navbar").removeClass("show");
    } else {
        $("#side-navbar").addClass("show");
    }
}

window.onresize = sidebarCollapseChange;


//body functions
let sidetabHover = function() {
    $(".sidebar-tab").hover(
        function() {
            $(this).addClass("sidetab-hover");
        },
        function() {
            $(this).removeClass("sidetab-hover");
        }
    );
}