var gamestate_id;
var player_color
var board;              //2D array
var width;              //of board
var height;             //of board
var legal_moves;        //2D array of same size as board

//functions in this file :
//function clicked(obj);
//function send_move(i, j);
//function update_board();
//function create_html_board();
//function update_display_board();
//function create_gamestate(problem_id);
//function update_legal_moves();

$(document).ready(function(){
    console.log("Started script.");

    var problem_id = parseInt($("#problem_id").text());
    if(problem_id == undefined || isNaN(problem_id)){
      console.log("Main function : could not parse problem_id : " + problem_id.toString());
    }

    create_gamestate(problem_id);
    update_player_color();
    update_board();
    create_html_board();
    update_display_board();
    update_legal_moves();
})

/**
* \brief function called when a user clicks a square on the board.
*        It is passed the object that was clicked.
*/
function clicked(obj){
    console.log("User clicked.");
    row = parseInt(obj.id[0]);
    column = parseInt(obj.id[2]);
    if(legal_moves[row][column]){
        if(player_color == 1){
            $("#" + row + "-" + column).attr('class', 'black');
        }
        if(player_color == 2){
            $("#" + row + "-" + column).attr('class', 'white');
        }

        //window.requestAnimationFrame(function(){ });
        setTimeout(send_move, 100, row, column);
        //send_move(row, column);
    }
    else{
        console.log("But the move is not legal.");
    }
}

/**
* \brief sends move to server and updates board and its display afterwards, as well as legal moves.
*/
function send_move(i, j){
    if(gamestate_id == undefined || isNaN(gamestate_id) || gamestate_id == -1){
        console.log("In send_move() : gamestate_id not valid. gamestate_id : " + gamestate_id.toString());
    }

    var url = "/move?id=" + gamestate_id.toString() + "&i=" + i.toString() + "&j=" + j.toString();
    var request = $.get(url, null, after_send);
    request.fail(function(jqXHR){
        console.log("Get request to send move failed.");
        display_rails_error(jqXHR)
    });

    //FUNCTION THAT IS CALLED AFTER THE MOVE IS SENT :
    function after_send(data){
        if(is_error_code(data)){
            display_custom_error(data);
        }
        console.log("after_send() : successfully sent move (" + i.toString() + ", " + j.toString() + ")");
        update_board();
        update_display_board();
        update_legal_moves();
    }
}

/**
* \brief Asks the server for the board, and updates the global variable "board".
*/
function update_board(){
    console.log("Updating board.");

    if(gamestate_id == undefined || isNaN(gamestate_id) || gamestate_id == -1){
        console.log("update_board(): gamestate_id not valid. gamestate_id : " + gamestate_id);
    }

    var req = $.get({url : "/get_board?id=" + gamestate_id.toString(),
                     complete : after_get_board,
                     async : false});
    req.fail(function(jqXHR){
        console.log("update_board() : Get request to get board failed.");
        display_rails_error(jqXHR);
    });

    function after_get_board(jqXHR){
        var data = jqXHR.responseText;
        console.log("Successfully recieved board data : " + data);

        if(is_error_code(data)){
            display_custom_error(data);
            return;
        }

        var board_of_stones = [];
        board_of_stones[0] = [];
        var i = 0;
        var cur_row = 0, cur_column = 0;

        //load board_of_stones
        while(1){
            if(data[i] == undefined){
                break;
            }
            else if("012".search(data[i]) > -1){
                board_of_stones[cur_row][cur_column] = parseInt(data[i]);
                cur_column++;
            }
            else if(data[i] == "\n"){
                if(data[i+1] != "\n" && data[i+1] != undefined){
                    cur_row++;
                    board_of_stones[cur_row] = [];
                    cur_column = 0;
                }
            }
            else{
                console.log("after_get_board() : Unvalid data recieved from the server !");
            }
            i++;
        }

        //update global variables
        height = board_of_stones.length;
        width = board_of_stones[0].length;
        board = board_of_stones;

        console.log("Updated board into array. height : " + height.toString() + " width : " + width.toString());
    }
}

/**
* \brief Builds the HTML code needed to display the board given in the global variable
*/
function create_html_board(){
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
        }
    }
    console.log("Created html tags.");
}

/**
* \brief updates the display of the board. The global variable 'board' has to be set, and the html tags have to be there.
*/
function update_display_board(){
    if(board == undefined || width == undefined || height == undefined){
        console.log("update_display_board() : cannot build html because board was not initialized");
        return;
    }

    if($("#board").html().search("<table>") < 0){
        console.log("update_display_board : The html was not created. See #board : " + $("#board").html());
        console.log("$('#board').html().search('<table>') = " + $("#board").html().search("<table>"));
        return;
    }

    for(var i = 0; i < height; i++){
        for(var j = 0; j < width; j++){
            if(board[i][j] == 0){
                $("#" + i + "-" + j).attr('class', 'empty');
            }
            else if(board[i][j] == 1){
                $("#" + i + "-" + j).attr('class', 'black');
            }
            else if(board[i][j] == 2){
                $("#" + i + "-" + j).attr('class', 'white');
            }
        }
    }
    console.log("Updated html according to the board global variable.");
}

/**
* \brief Asks the server to create a gamestate, and then retrieves the gamestate id
*/
function create_gamestate(problem_id){
    function after_create_game(jqXHR){
        var data = jqXHR.responseText;
        if(is_error_code(data)){
            display_custom_error(data);
            return;
        }

        gamestate_id = parseInt(data);
        if (gamestate_id == undefined){
            console.log("Something went wrong while retrieving gamestate_id");
        }
        else if (isNaN(gamestate_id)){
            console.log("Server responded badly to /create_gamestate");
        }
        else if(gamestate_id == -1){
            console.log("Server could not generate a gamestate with the problem you asked for.");
        }
        else{
            console.log("Successfully retrieved gamestate_id : " + gamestate_id.toString());
        }
    }

    var req = $.get({url: "/create_game?problem_id=" + problem_id.toString(),
                     complete: after_create_game,
                     async: false});
    req.fail(function(jqXHR){
        console.log("Get request to create gamestate failed.");
        display_rails_error(jqXHR);
    });

    $("#board_info").append("<br/>Your game has id : " + gamestate_id.toString());
}

/**
* \brief asks the server for the current legal moves, and updates the global variable legal_moves
*/
function update_legal_moves(){
    console.log("Updating legal moves.");
    if(gamestate_id == undefined || isNaN(gamestate_id) || gamestate_id == -1){
        console.log("In update_legal_moves(): gamestate_id not valid. gamestate_id : " + gamestate_id);
    }

    var req = $.get({url : "/get_legal?id=" + gamestate_id.toString(),
                     complete : after_get_legal,
                     async : false});
    req.fail(function(jqXHR){
        console.log("update_legal_moves() : Get request to get legal moves failed.");
        display_rails_error(jqXHR);
    });

    //FUNCTION CALLED AFTER THE GET REQUEST
    function after_get_legal(jqXHR){
        var data = jqXHR.responseText;
        if(is_error_code(data)){
            display_custom_error(data);
            return;
        }
        console.log("after_get_legal() : successfully received legal moves : " + data);

        var legal_moves_temp = [];
        legal_moves_temp[0] = [];
        var cur_row = 0;
        var cur_column = 0;
        var i = 0;

        while(1){
            if(data[i] == undefined){
                break;
            }
            else if("01".search(data[i]) > -1){
                legal_moves_temp[cur_row][cur_column] = parseInt(data[i]);
                cur_column++;
            }
            else if(data[i] == "\n"){
                if(data[i+1] != "\n" && data[i+1] != undefined){
                    cur_row++;
                    legal_moves_temp[cur_row] = [];
                    cur_column = 0;
                }
            }
            else{
                console.log("after_get_legal() : Unvalid data recieved from the server.")
            }
            i++;
        }
        legal_moves = legal_moves_temp; //update global variable
    }
}

/**
* \brief Asks the server for the player's color and updates the global variable player_color
*/
function update_player_color(){
    console.log("Updating player's color.");
    if(gamestate_id == undefined || isNaN(gamestate_id) || gamestate_id == -1){
        console.log("In update_legal_moves(): gamestate_id not valid. gamestate_id : " + gamestate_id);
    }

    var req = $.get("/get_color?id=" + gamestate_id.toString(), null, after_get_color);
    req.fail(function(jqXHR){
        console.log("update_player_color() : Get request to get player color failed.");
        display_rails_error(jqXHR);
    });

    //FUNCTION CALLED AFTER THE GET REQUEST
    function after_get_color(data){
        if(is_error_code(data)){
            display_custom_error(data);
            return;
        }
        console.log("after_get_color() : successfully received player color : " + data);

        player_color = parseInt(data); //update global variable

        if(player_color == undefined || isNaN(player_color)){
            console.log("after_get_color() : Could not parse player_color");
        }
    }
}



function sleep(milliSeconds){
        var startTime = new Date().getTime();
        while (new Date().getTime() < startTime + milliSeconds);
}

function display_rails_error(jqXHR){
    $("#error").append(jqXHR.responseText);
}

function is_error_code(data){
    return data[0] == "E";
}

function display_custom_error(data){
    if(! is_error_code(data)){
        console.log("display_custom_error() : not an error.");
    }

    if(data.search("E00")){
        console.log("Erreur 00");
    }
    if(data.search("E01")){
        console.log("Erreur 00");
    }
    if(data.search("E02")){
        console.log("Erreur 00");
    }
    if(data.search("E03")){
        console.log("Erreur 00");
    }
    if(data.search("E04")){
        console.log("Erreur 00");
    }
}