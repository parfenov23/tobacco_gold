//= require_tree ./vendor
//= require_tree ./common

show_error = function (text, duration) {
    var el = $('#alert');
    el.find('.text').text(text);
    el.show(300);
    el.find('.close').click(function () {
        el.hide(400);
    });
    if (duration){
        setTimeout(function () {
            el.hide(400);
        }, duration);
    }

};

function hide_to_top() {
    var scrollHeight = $(document).scrollTop(),
    windowHeight = $(window).height();
    if (scrollHeight > (windowHeight / 2)){
        //if (windowHeight > 500){
            $('#to-top').fadeIn(500);
            $('#to-top a').fadeIn(500);
        //}
    } else {
        //if (windowHeight > 500){
            $('#to-top').fadeOut(500);
            $('#to-top a').fadeOut(500);
        //}

    }
}
$(document).scroll(function () {
    hide_to_top()
});
$(document).ready(function () {
    hide_to_top();
    $('#to-top a').on('click', function (e) {
        event.preventDefault();
        $('html, body').stop()
        .animate({scrollTop: '0'}, 500);
        e.preventDefault();
    });

    $(document).on('click', '.js__openLeftSideBarMenu', function(){
        if ($(this).hasClass('active')){
            $("section.left-sidebar__wrp aside").css({left: "-100%"});
        }else{
            $("section.left-sidebar__wrp aside").css({left: "0"});
        }
        $( this ).toggleClass( "active" );
    });
});
