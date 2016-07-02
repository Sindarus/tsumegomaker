var b;                  //board object (board_of_stone, height, width, not_border)
var paint;              //color of the stone to add when you click

$(document).ready(function(){
    console.log("Started create.js");

    //hide validate button
    $("#validate").attr("style", "display: none;");

    //select a default color
    choose_paint(1);

    $("#create_board").on("click", function(){
        create_board();
        $("#validate").attr("style", "display: auto;");
    });
    $("#black_paint").on("click", function(){ choose_paint(1); });
    $("#white_paint").on("click", function(){ choose_paint(2); });
    $("#clear_board").on("click", function(){ clear_board(); });
    $("#validate").on("click", send_problem);
});

/**
* This function retrives the info needed to create a board from the form on the page,
* then it calls create_html_board.
*/
function create_board(){
    console.log("Retrieving info of board");

    b = new Object;

    // retrieve dimentions
    b.width = parseInt($("#board_width").val());
    b.height = parseInt($("#board_height").val());
    if(b.width == undefined || isNaN(b.width) || b.height == undefined || isNaN(b.height)){
        console.log("Could not parse width and height from html form.");
        return;
    }

    //retrieve not_border
    b.not_border = [$("#not_border_up").prop("checked"),
                     $("#not_border_left").prop("checked"),
                     $("#not_border_right").prop("checked"),
                     $("#not_border_down").prop("checked")];

    console.log("Will be creating a board " + b.height.toString() + "x" + b.width.toString() + " not_border: " + b.not_border.toString());

    //remove form
    $("#board_size_form").remove();

    //handle html modifications
    create_html_board(b);
    init_hover();

    //handle "b.board_of_stone" global variable creation
    b.board_of_stone = new Array();
    for (var i = 0; i < b.height; i++) {
        b.board_of_stone[i] = new Array(b.width);
        for(var j = 0; j < b.width; j++){
            b.board_of_stone[i][j] = 0;
        }
    }
}

/*
* Adds "legal_move" class to every square of the board. The class is then changed by the function that adds the stone.
*/
function init_hover(){
    console.log("Init hover. height : " + b.height);
    for(var i = 0; i<b.height; i++){
        for(var j = 0; j<b.width; j++){
            select_stone(i, j).addClass("legal_move");
        }
    }
}

/*
* changes the global variable paint, and updates the board's class accordingly.
*/
function choose_paint(color){
    paint = color;
    var board_tag = $("#board");
    if(paint == 1){
        board_tag.attr("class", "player_black");
    }
    else if(paint == 2){
        board_tag.attr("class", "player_white");
    }
    else {
        console.log("choose_paint() : unknown color.");
    }
}

/* Clears the board global variable */
function clear_board(){
    console.log("clearing board");
    for(var i = 0; i<b.height; i++){
        for(var j = 0; j<b.width; j++){
            b.board_of_stone[i][j] = 0;
            select_stone(i, j).attr("class", "legal_move");
        }
    }
}

/**
 * \brief updates the display of the board. The global variable 'b' has to be set, and the html tags have to be there.
 */
function update_display_board(){
    if(b == undefined || b.width == undefined || b.height == undefined){
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
            var elt = select_stone(i, j);
            if(b.board_of_stone[i][j] == 0){
                elt.attr('class', 'legal_move');
            }
            else if(b.board_of_stone[i][j] == 1){
                elt.attr('class', 'black_stone');
            }
            else if(b.board_of_stone[i][j] == 2){
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

    if(b.board_of_stone[i][j] == 1 || b.board_of_stone[i][j] == 2){
        //if there is already a stone there, delete it and return.
        b.board_of_stone[i][j] = 0;
        select_stone(i, j).attr("class", "legal_move");
        console.log("Removed a stone at (" + i.toString() + ", " + j.toString() + ")");
        return;
    }

    //from there on, we know (i, j) is already empty
    b.board_of_stone[i][j] = paint;

    var elt = select_stone(i, j);
    if(paint == 1){
        elt.attr("class", "black_stone");
    }
    else if(paint == 2){
        elt.attr("class", "white_stone");
    }
    else if(paint == 0){
        elt.attr("class", "legal_move");
    }
    else{
        console.log("User clicked to add a stone but 'paint' is wrong.");
    }

    console.log("Painted (" + i.toString() + ", " + j.toString() + ") to " + paint.toString());
}

function send_problem(){
    console.log("sending problem");
    $.post("/problem/submit", { board:JSON.stringify(b) }, function(data) {
        alert("server responded : " + data);
    });
}