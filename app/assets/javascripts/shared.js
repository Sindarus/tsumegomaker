/**
* \brief Builds the HTML code needed to display the board given in parameter, inside
* the tag #board
*/
function create_html_board(b){
    console.log("Creating html tags.");

    //checking if b is defined
    if(b == undefined){
        console.log("create_html_board() : cannot build html because board was not initialized");
        return;
    }

    //checking whether the html of the board has already been created
    var board_tag = $("#board");
    if(board_tag.html() != undefined) {
        if (board_tag.html().search("<table>") >= 0) {
            console.log("create_html_board() : html for board has already been build. See #board : " + $("#board").html());
            return;
        }
    }

    //creating the html
    var i, j;
    board_tag.append("<table/>");
    for(i = 0; i<b.height; i++){
        //creating 'tr' tag inside 'table'
        var table_row = $("<tr>", {id: i});
        table_row.appendTo("table");

        for(j = 0; j<b.width; j++){
            //creating 'td' tag inside 'tr'
            //class 'board_square' is to indicate that this tag is a board square,
            //'middle' is to indicate that this square is in a middle square. Could be
            //'down_border' or 'left_border' or 'down_right_corner' ... etc
            var table_data = $("<td/>", {id: i + "-" + j, class: "board_square middle"});
            table_data.appendTo(table_row);
            //creating 'div' tag inside 'td', used for holding the class indicating
            //the color of the stone, can be 'empty', 'legal_move', 'white', 'black'
            var div = $("<div/>", {class: "empty"});
            div.appendTo(table_data);
        }
    }

    //adding events on every square
    for(i = 0; i<b.height; i++){
        for(j = 0; j<b.width; j++){
            select_square(i, j).on("click", function(){ clicked(this); });
        }
    }

    //drawing corner squares
    var up_left_square = select_square(0, 0);
    var up_right_square = select_square(0, b.width-1);
    var down_left_square = select_square(b.height-1, 0);
    var down_right_square = select_square(b.height-1, b.width-1);
    //up_left_square
    if(b.not_border[0]){
        if(b.not_border[1])
            up_left_square.attr("class", "board_square middle");
        else
            up_left_square.attr("class", "board_square left_border");
    }
    else{
        if(b.not_border[1])
            up_left_square.attr("class", "board_square up_border");
        else
            up_left_square.attr("class", "board_square up_left_corner");
    }
    //up_right_square
    if(b.not_border[0]){
        if(b.not_border[2])
            up_right_square.attr("class", "board_square middle");
        else
            up_right_square.attr("class", "board_square right_border");
    }
    else{
        if(b.not_border[2])
            up_right_square.attr("class", "board_square up_border");
        else
            up_right_square.attr("class", "board_square up_right_corner");
    }
    //down_left_square
    if(b.not_border[3]){
        if(b.not_border[1])
            down_left_square.attr("class", "board_square middle");
        else
            down_left_square.attr("class", "board_square left_border");
    }
    else{
        if(b.not_border[1])
            down_left_square.attr("class", "board_square down_border");
        else
            down_left_square.attr("class", "board_square down_left_corner");
    }
    //down_right_square
    if(b.not_border[3]){
        if(b.not_border[2])
            down_right_square.attr("class", "board_square middle");
        else
            down_right_square.attr("class", "board_square right_border");
    }
    else{
        if(b.not_border[2])
            down_right_square.attr("class", "board_square down_border");
        else
            down_right_square.attr("class", "board_square down_right_corner");
    }

    //drawing borders
    if(! b.not_border[0]){
        i = 0;
        for(j = 1; j<b.width-1; j++){
            select_square(i, j).attr('class', 'board_square up_border');
        }
    }
    if(! b.not_border[3]){
        i = b.height-1;
        for(j = 1; j<b.width-1; j++){
            select_square(i, j).attr('class', 'board_square down_border');
        }
    }
    if(! b.not_border[1]){
        j = 0
        for(i = 1; i<b.height-1; i++){
            select_square(i, j).attr('class', 'board_square left_border');
        }
    }
    if(! b.not_border[2]){
        j = b.width-1
        for(i = 1; i<b.height-1; i++){
            select_square(i, j).attr('class', 'board_square right_border');
        }
    }

    //drawing not borders
    //up
    if(b.not_border[0]){
        var my_tr = $("<tr>", {id: "up_not_border"});
        my_tr.prependTo("table");       //add a tr at the top
        for(var j = 0; j < b.width; j++){
            //for each square of the first row, copy its class and create a td
            //with the same class above it
            var cur_class = select_square(0, j).attr('class');
            $("<td>", {class: cur_class + " not_border fade_up"}).appendTo(my_tr);
        }
    }
    //down
    if(b.not_border[3]){
        var my_tr = $("<tr>", {id: "down_not_border"});
        my_tr.appendTo("table");
        for(var j = 0; j < b.width; j++){
            //for each square of the last row, copy its class and create a td
            //with the same class under it
            var cur_class = select_square(b.height-1, j).attr('class');
            $("<td>", {class: cur_class + " not_border fade_down"}).appendTo(my_tr);
        }
    }
    //left
    if(b.not_border[1]){
        for(var i = 0; i < b.height; i++){
            var cur_class = select_square(i, 0).attr('class');
            $("<td>", {class: cur_class + " not_border fade_left"}).prependTo("tr#" + i.toString());
        }
    }
    //right
    if(b.not_border[2]){
        for(var i = 0; i < b.height; i++){
            var cur_class = select_square(i, b.width-1).attr('class');
            $("<td>", {class: cur_class + " not_border fade_right"}).appendTo("tr#" + i.toString());
        }
    }

    //drawing corner of not_borders
    //upleft
    if(b.not_border[0]){
        if(b.not_border[1]){
            $("<td>", {class: "board_square middle not_border fade_up_left"}).prependTo("tr#up_not_border");
        }
        if(b.not_border[2]){
            $("<td>", {class: "board_square middle not_border fade_up_right"}).appendTo("tr#up_not_border");
        }
    }
    if(b.not_border[3]){
        if(b.not_border[1]){
            $("<td>", {class: "board_square middle not_border fade_down_left"}).prependTo("tr#down_not_border");
        }
        if(b.not_border[2]){
            $("<td>", {class: "board_square middle not_border fade_down_right"}).appendTo("tr#down_not_border");
        }
    }

    //checking if the function worked
    if(board_tag.html() == undefined){
        console.log("something went wrong creating html tags, because board_tag.html() is undefined");
    }
}

//html tag that has the class "board_square" and the class "middle" or "left_border" or ...
function select_square(i, j){
    return $("#" + i.toString() + "-" + j.toString());
}

//html tag that has the class "white_stone", "black_stone", "empty" or "legal_move"
function select_stone(i, j){
    return $("#" + i.toString() + "-" + j.toString() + " div");
}

function display_rails_error(jqXHR){
    $("#error").append(jqXHR.responseText);
}
