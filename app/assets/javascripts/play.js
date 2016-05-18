var gamestate_id;
var board;              //2D array
var legal_moves;        //2D array of same size as board

$(document).ready(function(){
    console.log("Started script.");
    var problem_id = parseInt($("#problem_id").text());
    if(problem_id == undefined || isNaN(problem_id)){
      console.log("Main function : could not parsed problem_id : " + problem_id.toString());
    }
    create_gamestate(problem_id);
    get_and_load_board(true);
    update_legal_moves();
})

function clicked(obj){
    console.log("User clicked.");
    row = parseInt(obj.id[0]);
    column = parseInt(obj.id[2]);
    if(legal_moves[row][column]){
        send_move(row, column);
    }
    else{
        console.log("But the move is not legal.");
    }
}

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
        console.log("successfully sent move (" + i.toString() + ", " + j.toString() + ")");
        load_board(data, false);
        update_legal_moves();
    }
}

/**
* \fn function update_board(data, create = false);
* \param data a board in form of a string
* \param create boolean : should we create html tags that hold the board ?
* \brief From a given board string, this function will load the board on screen. It will update the html.
*/
function load_board(data, create = false){
    console.log("Successfully received board data : " + data);
    //'data' is automatically passed to the anonymous function

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
            console.log("load_board() : Unvalid data recieved from the server ! Please retry.")
        }
        i++;
    }
    var height = board_of_stones.length;
    var width = board_of_stones[0].length;
    board = board_of_stones;    //update global variable
    console.log("Loaded board into an array. height : " + height.toString() + " width : " + width.toString());

    //create html tags
    if(create){
        $("#board").append("<table/>");

        for(var i = 0; i<height; i++){
            var table_row = $("<tr>", {id: i});
            table_row.appendTo("table");

            for(var j = 0; j<width; j++){
                var table_data = $("<td/>", {id: i + "-" + j, text: ""});
                table_data.appendTo("tr#" + i);
                //$("#board").append(".");
            }
        }

        for(var i = 0; i<height; i++){
            for(var j = 0; j<width; j++){
                $("#" + i + "-" + j).on("click", function(){ clicked(this); })
            }
        }
        console.log("Created html tags.");
    }

    //update html
    for(var i = 0; i < height; i++){
        for(var j = 0; j < width; j++){
            if(board_of_stones[i][j] == 0){
                $("#" + i + "-" + j).attr('class', 'empty');
            }
            else if(board_of_stones[i][j] == 1){
                $("#" + i + "-" + j).attr('class', 'black');
            }
            else if(board_of_stones[i][j] == 2){
                $("#" + i + "-" + j).attr('class', 'white');
            }
        }
    }
    console.log("Updated html according to the board we just recieved.");
}

function create_gamestate(problem_id){
    function get_gamestate_id(jqXHR, textStatus){
        if(textStatus != "success"){
            console.log("Get request to create gamestate failed.");
            display_rails_error(jqXHR);
        }

        data = jqXHR.responseText;
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

    $.get({url: "/create_game?problem_id=" + problem_id.toString(),
           complete: get_gamestate_id,
           async: false});

    $("#board_info").append("<br/>Your game has id : " + gamestate_id.toString());
}

/**
* \fn function get_and_load_board(create = false);
* if create is set to true, the function will create the html tags.
*/
function get_and_load_board(create = false){
    if(gamestate_id == undefined || isNaN(gamestate_id) || gamestate_id == -1){
        console.log("In get_and_load_board(): gamestate_id not valid. gamestate_id : " + gamestate_id);
    }
    var req = $.get("/get_board?id=" + gamestate_id.toString(), null, function(data){ load_board(data, create) });
    req.fail(function(jqXHR){
        console.log("get_and_load_board : Get request to get board failed.");
        display_rails_error(jqXHR);
    });
}

function update_legal_moves(){
    console.log("Updating legal moves.");
    if(gamestate_id == undefined || isNaN(gamestate_id) || gamestate_id == -1){
        console.log("In update_legal_moves(): gamestate_id not valid. gamestate_id : " + gamestate_id);
    }

    var req = $.get("/get_legal?id=" + gamestate_id.toString(), null, after_get_legal);
    req.fail(function(jqXHR){
        console.log("update_legal_moves() : Get request to get legal moves failed.");
        display_rails_error(jqXHR);
    });

    //FUNCTION CALLED AFTER THE GET REQUEST
    function after_get_legal(data){
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

function display_rails_error(jqXHR){
    $("#error").append(jqXHR.responseText);
}
