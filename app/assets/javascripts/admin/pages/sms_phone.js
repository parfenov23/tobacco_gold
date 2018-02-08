var smsPhonePay = function(){
  var btn = $(this);
  var form = btn.closest("form");
  ajaxApi('get', form.attr("action"), form.serializeHash(), function(){
    btn.closest(".removeParentBlock").remove();
  });
}

$(document).ready(function(){
  $(document).on('click', '.js_smsPhonePay', smsPhonePay);
});