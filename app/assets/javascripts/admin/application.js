//= require_tree ./pages
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
    console.log()
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


$(document).ready(function(){
  $(document).on('click', '.js_loadContentInOtherPopup', function(event){
    event.preventDefault();
    loadContentInOtherPopup($(this));
  });
  $(document).on('click', '.js_submitNewModel', function(event){
    event.preventDefault();
    submitNewModel($(this));
  })
})