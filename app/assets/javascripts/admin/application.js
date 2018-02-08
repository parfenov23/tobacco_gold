//= require_tree ./pages
//= require vendor/serialize_file

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

var loadContentInOtherPopup = function(btn){
  var title = $(btn).data('title');
  openAllOtherPopup(title, function(){
    var url = $(btn).attr("href");
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

$(document).ready(function(){
  $(document).on('click', '.js_loadContentInOtherPopup', function(event){
    event.preventDefault();
    loadContentInOtherPopup($(this));
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