var openPopupAuth = function(){
  $(".popupAuth").show();
  $('#overlay').addClass('dark-overlay')
}

var selectPlanTariff = function(){
  $(".plan").hide();
  $(".plan[data-type='"+  $(this).data("plan") +"']").show();
}

$(document).ready(function(){
  $(".js_openPopupAuth").on('click', openPopupAuth);
  $(".js_selectPlanTariff button").on('click', selectPlanTariff);
});