//= require_tree ./pages
//= require vendor/serialize_file
// Pusher.logToConsole = true;
var pusher = new Pusher('1a55ade886312565bd6d', {
  cluster: 'eu',
  encrypted: true
});


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

var getTitleAndHrefBtnInOtherPopup = function(btn){
  var title = $(btn).data('title');
  var url = $(btn).attr("href");
  loadContentInOtherPopup(title, url);
}

var loadContentInOtherPopup = function(title, url){
  openAllOtherPopup(title, function(){
    $.ajax({
      type   : 'get',
      url    : url,
      data   : {typeAction: "json"},
      success: function (data) {
        $(".allOtherPopup .conteinerPopup").html($(data));
      },
      error  : function () {
        show_error('Ошибка', 3000);
      }
    });
  });
}

var submitNewModel = function(btn){
  var btn = $(btn);
  var form = btn.closest("form");
  var data = form.serializeArray();
  data.push({name: 'typeAction', value: "json"})

  $.ajax({
    type   : 'POST',
    url    : form.attr("action"),
    data   : data,
    success: function (data) {
      location.reload();
    },
    error  : function () {
      show_error('Ошибка', 3000);
    }
  });
}

var current_user_api_key = function(){
  return $("#currentUserApiKey").val();
}

var current_user_api_url = function(){
  return $("#currentUserUrl").val();
}
var current_user_magazine_id = function(){
  return $("#currentMagazineId").val();
}

var ajaxApi = function(type, method, data, end_action, view_error){
  if (data == undefined) data = {};
  if (view_error == undefined) view_error = true;
  var auth = {api_key: current_user_api_key};
  var params = $.extend(auth, data); 

  $.ajax({
    type   : type,
    url    : (current_user_api_url() + method),
    data   : params,
    success: function (data) {
      if (end_action != undefined) end_action(data);
      if (view_error) show_error('Успешно', 3000);
      
    },
    error  : function () {
      show_error('Ошибка', 3000);
    }
  });
}

var btnAjaxRemove = function(btn_this){
  var btn = $(btn_this);
  ajaxApi('get', btn.attr("href"), {}, function(){
    btn.closest(".removeParentBlock").remove();
  });
}

var scanBarCode = function(end_function){
  var pressed = false; 
  var chars = []; 
  $(window).keypress(function(e) {
    if (e.which >= 48 && e.which <= 57) {
      chars.push(String.fromCharCode(e.which));
    }
    // console.log(e.which + ":" + chars.join("|"));
    if (pressed == false) {
      setTimeout(function(){
                // check we have a long length e.g. it is a barcode
                if (chars.length >= 10) {
                  end_function(chars.join(""))
                }
                chars = [];
                pressed = false;
              },500);
    }
    pressed = true;
  });
}

$(document).ready(function(){
  $(document).on('click', '.js_loadContentInOtherPopup', function(event){
    event.preventDefault();
    getTitleAndHrefBtnInOtherPopup($(this));
  });
  $(document).on('click', '.js_submitNewModel', function(event){
    event.preventDefault();
    submitNewModel($(this));
  });
  $(document).on('click', '.js__remove', function(event) {
    event.preventDefault();
    btnAjaxRemove(this);
  });
})