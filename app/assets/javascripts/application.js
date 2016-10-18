//= require_tree ./vendor
//= require_tree ./common

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
});
