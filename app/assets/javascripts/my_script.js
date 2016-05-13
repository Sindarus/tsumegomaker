var id_gamestate;

$(document).ready(function(){
    alert("Hello world2.");

    create_gamestate(1);
    load_board_state(true);
})

function clicked(obj){
    row = parseInt(obj.id[0]);
    column = parseInt(obj.id[2]);
    send_move(row, column);
    // alert("You have clicked. row : " + row);
    // alert("column : " + column);
}

function send_move(i, j){
    if(id_gamestate == undefined || isNaN(id_gamestate) || id_gamestate == -1){
        alert("id_gamestate not valid.");
    }
    $.get("/move?id=" + id_gamestate.toString() + "i=" + i.toString() + "&j=" + j.toString());
}

function create_gamestate(problem_id){
    $.get("/create_gamestate?id_problem=" + problem_id.toString(), null, function(data)){
        id_gamestate = parseInt(data);
        if (isNaN(id_gamestate)){
            alert("Server responded badly to /create_gamestate");
        }
        else if(id_gamestate != -1){
            alert("Server could not generate a gamestate with the problem you asked for.");
        }
    }
}

/**
* \fn function load_board_state(create = false);
* if create is set to true, the function will create the html tags.
*/
function load_board_state(create = false){
    $.get("/board?id=" + id_gamestate.toString(), null, function(data){
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
                cur_row++;
                board_of_stones[cur_row] = [];
                cur_column = 0;
            }
            else{
                alert("Unvalid data recieved from the server ! Please retry.")
            }
            i++;
        }
        var height = board_of_stones.length - 1;
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
    }, "text");
}

// // function load_legal_moves(){

// // }