var board;              //2D array
var width;              //of board
var height;             //of board
var paint;              //color of the stone to add when you click

$(document).ready(function(){
    console.log("Started create.js");

    $("#create_board").on("click", create_board);
    $("#black_paint").on("click", function(){ paint = 1; update_hover(); });
    $("#white_paint").on("click", function(){ paint = 2; update_hover(); });
    $("#empty_paint").on("click", function(){ paint = 0; update_hover(); });
    $("#clear_board").on("click", function(){ clear_board(); update_display_board(); })
});

function init_hover(){
    console.log("Init hover. height : " + height);
    for(var i = 0; i<height; i++){
        for(var j = 0; j<width; j++){
            $("#" + i + "-" + j + " div").addClass("legal_move");
        }
    }
}

function update_hover(){
    console.log("Update hover");
    var board_tag = $("#board");
    board_tag.removeClass("player_black player_white player_empty");
    if(paint == 1){
        board_tag.addClass("player_black");
    }
    else if(paint == 2){
        board_tag.addClass("player_white");
    }
    else if(paint == 0){
        board_tag.addClass("player_empty");
    }
}

function clear_board(){
    console.log("clearing board");
    for(var i = 0; i<height; i++){
        for(var j = 0; j<width; j++){
            board[i][j] = 0;
        }
    }
}

/**
 * \brief updates the display of the board. The global variable 'board' has to be set, and the html tags have to be there.
 */
function update_display_board(){
    if(board == undefined || width == undefined || height == undefined){
        console.log("update_display_board() : cannot build html because board was not initialized");
        return;
    }

    var board_tag = $("#board");
    if(board_tag.html() == undefined) {
        console.log("update_display_board : cannot update display because board_tag.html() is undefined. See #board : " + board_tag.html());
        return;
    }
    else if(board_tag.html().search("<table>") < 0) {
        console.log("update_display_board : cannot update display because the html was not created. See #board : " + board_tag.html());
        return;
    }

    for(var i = 0; i < height; i++){
        for(var j = 0; j < width; j++){
            var elt = $("#" + i + "-" + j + " div");
            if(board[i][j] == 0){
                elt.attr('class', 'legal_move');
            }
            else if(board[i][j] == 1){
                elt.attr('class', 'black_stone');
            }
            else if(board[i][j] == 2){
                elt.attr('class', 'white_stone');
            }
        }
    }
    console.log("Updated html according to the board global variable.");
}

function create_board(){
    console.log("Retrieving size of board");
    width = parseInt($("#board_width").val());
    height = parseInt($("#board_height").val());
    if(width == undefined || isNaN(width) || height == undefined || isNaN(height)){
        console.log("Could not parse width and height from html form.");
        return;
    }
    console.log("will be creating a board " + height.toString() + "x" + width.toString());

    paint = 1;
    init_board();
    create_html_board(width, height);
    init_hover();
    update_hover();

    $("#board_size_form").remove();
}

function init_board(){
    console.log("Initing board");
    board = [];
    for(var i = 0; i<height; i++){
        board[i] = [];
        for(var j = 0; j<width; j++){
            board[i][j] = 0;
        }
    }
}

/**
* \brief Builds the HTML code needed to display the board given in the global variable
*/
function create_html_board(width, height){
    console.log("Building html board");
    if(width == undefined || height == undefined){
        console.log("create_html_board() : cannot build html because I do not know the width or height.");
        return;
    }

    var board_tag = $("#board");
    if(board_tag.html() != undefined){
        if(board_tag.html().search("<table>") >= 0) {   //if there is "<table>" in board_tag
            console.log("create_html_board() : html for board has already been build. See #board : " + $("#board").html());
            return;
        }
    }

    var i, j;
    board_tag.append("<table/>");
    for(i = 0; i<height; i++){
        var table_row = $("<tr>", {id: i});
        table_row.appendTo("table");

        for(j = 0; j<width; j++){
            var table_data = $("<td/>", {id: i + "-" + j, text: ""});
            table_data.append("<div>");
            table_data.appendTo("tr#" + i);
        }
    }

    for(i = 0; i<height; i++){
        for(j = 0; j<width; j++){
            var elt = $("#" + i + "-" + j);
            elt.on("click", function(){ clicked(this); });
            elt.attr('class', 'board_square');
        }
    }
    console.log("Created html tags.");
}

function clicked(obj){
    //alert("clicked : " + obj.toString());
    var i = parseInt(obj.id[0]);
    var j = parseInt(obj.id[2]);

    board[i][j] = paint;

    var elt = $("#" + i + "-" + j + " div");
    if(paint == 1){
        elt.attr("class", "black_stone");
        elt.removeClass("legal_move");
    }
    else if(paint == 2){
        elt.attr("class", "white_stone");
        elt.removeClass("legal_move");
    }
    else if(paint == 0){
        elt.attr("class", "empty_stone");
        elt.addClass("legal_move");
    }
    else{
        console.log("User clicked to add a stone but 'paint' is wrong.");
    }

    console.log("Painted (" + i.toString() + ", " + j.toString() + ") to " + paint.toString());
}
