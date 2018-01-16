$(document).ready(function(){
  include_mad_select($(".js_selectStatisticCachbox .mad-select").removeClass("noInit"), function(input){
    window.location.assign(window.location.pathname + "?date=" + input.val());
  });
  $(document).on('click', '.openMobileLeftBar', function(){ $(".leftContentBar").show(); })

  $(document).on('click', '.js_closeLeftBar' , function(){ $(".leftContentBar").hide(); })
})