var gamestate_id;

$(document).ready(function(){
    console.log("Started script.");

    create_gamestate(1);
    get_and_load_board(true);
})

function clicked(obj){
    console.log("Clicked.");
    row = parseInt(obj.id[0]);
    column = parseInt(obj.id[2]);
    send_move(row, column);
    // alert("You have clicked. row : " + row);
    // alert("column : " + column);
}

function send_move(i, j){
    if(gamestate_id == undefined || isNaN(gamestate_id) || gamestate_id == -1){
        console.log("In send_move() : gamestate_id not valid. gamestate_id : " + gamestate_id.toString());
    }

    var url = "/move?id=" + gamestate_id.toString() + "&i=" + i.toString() + "&j=" + j.toString();
    var request = $.get(url, null, function(data){
        console.log("successfully sent move (" + i.toString() + ", " + j.toString() + ")");
        load_board(data, false);
    });
    request.fail(function(jqXHR){
        console.log("Get request to send move failed. Data : " + jqXHR.responseText());
    });
}

function create_gamestate(problem_id){
    function get_gamestate_id(jqXHR, textStatus){
        if(textStatus != "success"){
            alert("Get request to create gamestate failed. data : " + jqXHR.responseText);
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
    var done = false;
    var cur_row = 0, cur_column = 0;

    //load board_of_stones
    while(!done){
        if(data[i] == undefined){
            done = true;
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
            console.log("Unvalid data recieved from the server ! Please retry.")
        }
        i++;
    }
    var height = board_of_stones.length;
    var width = board_of_stones[0].length;
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

/**
* \fn function get_and_load_board(create = false);
* if create is set to true, the function will create the html tags.
*/
function get_and_load_board(create = false){
    if(gamestate_id == undefined || isNaN(gamestate_id) || gamestate_id == -1){
        alert("In get_and_load_board(): gamestate_id not valid. gamestate_id : " + gamestate_id);
    }
    var req = $.get("/get_board?id=" + gamestate_id.toString(), null, function(data){ load_board(data, create) });
    req.fail(function(jqXHR){
        console.log("get_and_load_board : Get request to get board failed. Data : " + jqXHR.responseText);
        display_rails_error(jqXHR);
    });
}

// // function load_legal_moves(){

// // }


function display_rails_error(jqXHR){
    $("#error").append(jqXHR.responseText);
}