var gamestate_id;

$(document).ready(function(){
    alert("Hello world2.");

    create_gamestate(1);
    get_and_load_board(true);
})

function clicked(obj){
    row = parseInt(obj.id[0]);
    column = parseInt(obj.id[2]);
    send_move(row, column);
    // alert("You have clicked. row : " + row);
    // alert("column : " + column);
}

function send_move(i, j){
    if(gamestate_id == undefined || isNaN(gamestate_id) || gamestate_id == -1){
        alert("In send_move() : gamestate_id not valid.");
    }

    $.get("/move?id=" + gamestate_id.toString() + "&i=" + i.toString() + "&j=" + j.toString(),
          null,
          function(data){ alert("send move went well"); load_board(data, false); });

}

function create_gamestate(problem_id){
    function get_gamestate_id(jqXHR, textStatus){
        if(textStatus != "success"){
            alert("get request failed");
        }

        data = jqXHR.responseText;
        gamestate_id = parseInt(data);
        if (gamestate_id == undefined){
            alert("Something went wrong while retrieving gamestate_id");
        }
        else if (isNaN(gamestate_id)){
            alert("Server responded badly to /create_gamestate");
        }
        else if(gamestate_id == -1){
            alert("Server could not generate a gamestate with the problem you asked for.");
        }
        else{
            //alert("successfully retrieved gamestate_id");
        }
    }

    $.get({url: "/create_game?problem_id=" + problem_id.toString(),
           complete: get_gamestate_id,
           async: false});
}


/**
* \fn function update_board(data, create = false);
* \param data a board in form of a string
* \param create boolean : should we create html tags that hold the board ?
* \brief From a given board string, this function will load the board on screen. It will update the html.
*/
function load_board(data, create = false){
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
            alert("Unvalid data recieved from the server ! Please retry.")
        }
        i++;
    }
    var height = board_of_stones.length;
    var width = board_of_stones[0].length;

    //create html tags
    if(create){
        for(var i = 0; i<height; i++){
            for(var j = 0; j<width; j++){
                var span = $("<span/>", {id: i + "-" + j, text: "__"});
                span.appendTo(".board");
                $(".board").append(".");
            }
            $(".board").append("<br/>");
        }

        for(var i = 0; i<height; i++){
            for(var j = 0; j<width; j++){
                $("#" + i + "-" + j).on("click", function(){ clicked(this); })
            }
        }
    }

    //update html
    for(var i = 0; i < height; i++){
        for(var j = 0; j < width; j++){
            if(board_of_stones[i][j] == 0){
                $("#" + i + "-" + j).attr('class', '');
            }
            else if(board_of_stones[i][j] == 1){
                $("#" + i + "-" + j).attr('class', 'black');
            }
            else if(board_of_stones[i][j] == 2){
                $("#" + i + "-" + j).attr('class', 'white');
            }
        }
    }
}

/**
* \fn function get_and_load_board(create = false);
* if create is set to true, the function will create the html tags.
*/
function get_and_load_board(create = false){
    if(gamestate_id == undefined || isNaN(gamestate_id) || gamestate_id == -1){
        alert("In get_and_load_board(): gamestate_id not valid. gamestate_id : " + gamestate_id);
    }
    $.get("/get_board?id=" + gamestate_id.toString(), null, function(data){ load_board(data, create) });
}

// // function load_legal_moves(){

// // }