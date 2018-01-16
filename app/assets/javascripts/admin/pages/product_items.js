// var submitNewModel = function(){
//   var btn = $(this);
//   var form = btn.closest("form");
//   var data = form.serializeArray();
//   data.push({name: 'typeAction', value: "json"})

//   $.ajax({
//     type   : 'POST',
//     url    : form.attr("action"),
//     data   : data,
//     success: function (data) {
//       location.reload();
//     },
//     error  : function () {
//       show_error('Ошибка', 3000);
//     }
//   });
// }

$(document).ready(function(){
  // $(document).on('click', '.js_submitNewModel', submitNewModel)
})