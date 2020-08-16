function help_notif(elem_hash) { // применение и настройка конкретного шага
    var block_help = $(".help_notif");
    var elem = $(elem_hash.block);
    var position_elem = {top: 0, left: 0};
    var elem_width = 0;
    var elem_height = 0;


    var win_width = $(window).width();
    var win_height = $(window).height();
    var content = block_help.find(".help_content");

    if (elem.length > 0){
        $(window).scrollTop(0);
        position_elem = cumulativeOffset(elem[0]);
        elem_width = elem.outerWidth();
        elem_height = elem.outerHeight();
    }
    var element_scroll = function (type) {
        if (elem.length > 0 && elem.css("position") != "fixed"){
            if (type == "top"){
                $(window).scrollTop(elem.position().top - content.outerHeight());
            }
            if (type == "bot"){
                $(window).scrollTop(elem.position().top - 100);
            }
        } else {
            $(window).scrollTop(0)
        }
    };
    var left_up_content = function () {
        content.css("left", (elem_width + 50) * (- 1) + "px")
            .css("top", (elem_height + 50) * (- 1) + "px");
    };
    $("html").css("overflow", "hidden");
    var left_content = function () {
        content.css("left", (elem_width + 50 + content.outerWidth()) * (- 1) + "px")
            .css("top", "10px");
    };
    var bot_content = function () {
        content.css("top", elem_height + 50 + "px").css("left", "50px");
    };
    var top_content = function () {
        content.css("top", (elem_height + 50 + content.outerHeight()) * (- 1) + "px").css("left", "10px");
    };
    var center_content = function () {
        content.css("left", (win_width / 2 - (content.outerWidth() / 2 ) ) + "px")
            .css("top", (win_height / 2 - (content.outerHeight() / 2 ) ) + "px");
    };

    var min_pos_w_h = 32;
    var min_pos_l_t = 16;
    if (elem.length == 0){
        min_pos_w_h = 0;
        min_pos_l_t = 0;
    }

    if (elem_width != elem_height){
        block_help.css("border-radius", "3px");
        min_pos_w_h = 0;
        min_pos_l_t = 0;
    } else {
        block_help.css("border-radius", "50%");
    }

    block_help.css("left", position_elem.left - min_pos_l_t)
        .css("top", position_elem.top - min_pos_l_t)
        .css("outline-color", elem_hash.color)
        .css("box-shadow", "0px 0px 1px 100px " + elem_hash.color)
        .css("width", elem_width + min_pos_w_h)
        .css("height", elem_height + min_pos_w_h);

    content.find(".main_content").html(elem_hash.content);
    content.find(".next_btn").html(elem_hash.btn_text).css("background-color", elem_hash.btn_color);
    content.find(".close_help").html(elem_hash.btn_close_text);
    content.find(".title").html(elem_hash.title);

    if (elem_hash.skip_btn == true){
        content.find(".close_help").hide();
        content.find(".next_btn").css("float", "right");
    } else {
        content.find(".close_help").show();
        content.find(".next_btn").css("float", "");
    }

    if (elem_hash.position == 'center'){
      content.addClass("fixCenter");
    }

    if (elem_hash.text_align != undefined){
        content.find(".main_content").css("text-align", elem_hash.text_align);
    } else {
        content.find(".main_content").css("text-align", "");
    }

    if (elem_hash.title != undefined && elem_hash.title != ""){
        content.find(".title").show();
    } else {
        content.find(".title").hide();
    }

    block_help.show();
    $(".overflowContentHelp").show();
    if (elem_hash.btn_action != "" && elem_hash.btn_action != undefined){
        content.find(".next_btn").attr("onclick", "actions_help('" + elem_hash.btn_action + "')");
        //actions_help(elem_hash.btn_action);
    }
    if (position_elem.left < win_width / 2 && position_elem.top < win_height / 2){
        bot_content();
        element_scroll("bot");
    }
    if (position_elem.left > win_width / 2 && position_elem.top < win_height / 2){
        left_content();
    }

    if (position_elem.left < win_width / 2 && position_elem.top > win_height / 2){
        top_content();
        element_scroll("top");
    }

    if (position_elem.left > win_width / 2 && position_elem.top > win_height / 2){
        left_up_content();
        element_scroll("top");
    }

    if (elem.length == 0){
        center_content();
    }

    if (elem_hash.btn_next_css != "" && elem_hash.btn_next_css != undefined){
        content.find(".next_btn").css(elem_hash.btn_next_css);
    }
}

function set_help(step) { // запуск помощи с вычесление текущего шага
    var step_help = $.session.get('step_help');
    var arr_helps = all_helps();
    var btn_next = $(".help_notif .next_btn");
    if (step_help == undefined){
        step_help = 0;
    }

    if (step != undefined){
        step_help = step
    }
    step_help = parseInt(step_help);
    $.session.set('step_help', step_help);
    if ((step_help) < arr_helps.length && $(".help_notif").data("show")){
        btn_next.data("step_next", step_help + 1);
        var help = arr_helps[step_help];
        help_notif(help)
    } else {
        read_help(false);
        $(".help_notif").hide();
        $(".overflowContentHelp").hide();
        $("html").css("overflow", "");
    }
}

var cumulativeOffset = function (element) {
    var top = 0, left = 0;
    do{
        top += element.offsetTop || 0;
        left += element.offsetLeft || 0;
        element = element.offsetParent;
    }while (element);

    return {
        top : top,
        left: left
    };
};

function read_help(type) { // обновление галочки у пользователя показывать или нет
    // $.ajax({
    //     type   : "post",
    //     url    : "/api/v1/users/update_help",
    //     success: function (response) {
    //     }
    // });
}
$(document).ready(function () {
    if ($(".help_notif").data("user") && $(".help_notif").data("show") && isMobile.any() == null){
        set_help();
        $(".help_notif .next_btn").click(function () {
            var btn = $(this);
            if (btn.attr('onclick') != undefined){
                var timeout = 50;
                var name_click = btn.attr('onclick');
                if (name_click.search('close_') > 0) timeout = 1;
                setTimeout(function () {
                    set_help(btn.data("step_next"));
                }, timeout);
            } else {
                set_help(btn.data("step_next"));
            }


        });
        $(".help_notif .help_content .close_help").click(function () {
            set_help(all_helps().length);
        });
    }

});