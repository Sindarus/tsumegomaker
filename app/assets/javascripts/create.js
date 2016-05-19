$(document).ready(function(){
    console.log("Started create.js");

    $("#create_board").on("click", create_board);
});

function create_board(){
    var width = parseInt($("#board_width").attr("value"));
    var height = parseInt($("#board_height").attr("value"));
    if(width == undefined || isNaN(width) || height == undefined || isNaN(height)){
        console.log("Could not parse width and height from html form.");
        return;
    }

    create_html_board(width, height);

    $("#board_size_form").remove();
}

/**
* \brief Builds the HTML code needed to display the board given in the global variable
*/
function create_html_board(width, height){
    if(board == undefined || width == undefined || height == undefined){
        console.log("create_html_board() : cannot build html because board was not initialized");
        return;
    }

    if($("#board").html().search("<table>") >= 0){
        console.log("create_html_board() : html for board has already been build. See #board : " + $("#board").html());
        return;
    }

    $("#board").append("<table/>");
    for(var i = 0; i<height; i++){
        var table_row = $("<tr>", {id: i});
        table_row.appendTo("table");

        for(var j = 0; j<width; j++){
            var table_data = $("<td/>", {id: i + "-" + j, text: ""});
            table_data.appendTo("tr#" + i);
        }
    }

    for(var i = 0; i<height; i++){
        for(var j = 0; j<width; j++){
            $("#" + i + "-" + j).on("click", function(){ clicked(this); });
            $("#" + i + "-" + j).attr('class', 'empty');
        }
    }
    console.log("Created html tags.");
}

function clicked(obj){
    alert("clicked : " + obj.toString());
}