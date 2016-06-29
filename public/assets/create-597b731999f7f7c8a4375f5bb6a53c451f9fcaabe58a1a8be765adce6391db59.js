var b;                  //board object (board_of_stones, height, width, not_borders)
var paint;              //color of the stone to add when you click

$(document).ready(function(){
    console.log("Started create.js");

    $("#create_board").on("click", create_board);
    $("#black_paint").on("click", function(){ paint = 1; update_hover(); });
    $("#white_paint").on("click", function(){ paint = 2; update_hover(); });
    $("#empty_paint").on("click", function(){ paint = 0; update_hover(); });
    $("#clear_board").on("click", function(){ clear_board(); update_display_board(); })
});

/**
* This function retrives the info needed to create a board from the form on the page,
* then it calls create_html_board.
*/
function create_board(){
    console.log("Retrieving info of board");

    b = new Object;
    b.width = parseInt($("#board_width").val());
    b.height = parseInt($("#board_height").val());
    if(b.width == undefined || isNaN(b.width) || b.height == undefined || isNaN(b.height)){
        console.log("Could not parse width and height from html form.");
        return;
    }

    b.not_borders = [$("#not_border_up").prop("checked"),
                     $("#not_border_left").prop("checked"),
                     $("#not_border_right").prop("checked"),
                     $("#not_border_down").prop("checked")];

    console.log("Will be creating a board " + height.toString() + "x" + width.toString() " not_borders: " + not_borders.toString());

    paint = 1;
    create_html_board(b);
    init_hover();
    update_hover();

    $("#board_size_form").remove();
}

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
