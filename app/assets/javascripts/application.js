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

var noUIinstall = function(){
    var slider = document.getElementById('sliderSort');
    noUiSlider.create(slider, {
        start: [0, 1000],
        connect: true,
        tooltips: true,
        format: 
        {
            to: function (value) {
              return Math.round(value) + ' Руб.';
            },
            from: function (value) {
              return value.replace('Руб.', '');
            }
        },
        range: {
            'min': 0,
            'max': 1000
        }
    });
}

var get_url_params_to_hash = function (hash){
    var pathname = window.location.pathname
    var array_urls = window.location.href.split("?")
    var all_params = ""
    if (array_urls.length > 1){
        all_params = array_urls[1].split("&")
    }
    var all_params_hash = {}
    $.each(all_params, function(k, v){
        var arr_p = v.split("=");
        all_params_hash[arr_p[0]] = arr_p[1]
    });
    var merge_params = $.extend(all_params_hash, hash);
    var all_merge_params = []
    $.each(merge_params, function(k, v){ all_merge_params.push(k + "=" + v) });
    return pathname + "?" + all_merge_params.join("&");
}

$(document).scroll(function () {
    hide_to_top()
});
$(document).ready(function () {
    hide_to_top();
    noUIinstall();
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

    $(document).on('click', '.js__submitBtnFormSliderSort', function(){
        var block_sort = $(this).closest(".sorting_slider").find("#sliderSort");
        var from = block_sort.find(".noUi-handle-lower .noUi-tooltip").text().split(" Руб.")[0];
        var to = block_sort.find(".noUi-handle-upper .noUi-tooltip").text().split(" Руб.")[0];
        window.location.href = get_url_params_to_hash({"price[from]": from, "price[to]": to})
    });


});
