var openAllOtherPopup = function(title, action = function(){}){
  $("body").css({overflow: "hidden"})
  $(".allOtherPopup").show();
  $(".allOtherPopup .fab-hdr h3").text(title)
  $("#overlay").addClass('dark-overlay');
  action();
}

var openFabPopup = function(){
  var popup = $(".fab");
  popup.removeClass("displayNone").addClass("active");
  popup.find(".conteinerPopup").show();
  popup.find(".fab-hdr").show();
  popup.data("type", "other_popup")
  $("#overlay").addClass("dark-overlay");
}

var closeAllOtherPopup = function(){
  $("body").css({overflow: "initial"});
  $(".allOtherPopup").hide();
  $("#overlay").removeClass('dark-overlay');
  closeFAB();
}

function closeFAB() {
  $("body").css({overflow: "initial"});
  $(".fab").find(".conteinerPopup, .fab-hdr").fadeOut(300);
  $(".allOtherPopup").hide();
  $(".popupAuth").hide();
  if ($(".fab").data("type") != "other_popup"){
    $(".fab").removeClass('active');
  }else{
    $(".fab").addClass("displayNone").removeClass('active');
  }
  
  $("#overlay").removeClass('dark-overlay');
}

function openFAB(event) {
  if (!$(".fab").hasClass("active") && !$(event.target).hasClass("closeBtn")){
    $("body").css({overflow: "hidden"})
    $(".fab").addClass('active');
    $(".fab").find(".conteinerPopup, .fab-hdr").fadeIn(300);
    $("#overlay").addClass('dark-overlay');
  }
}

$(document).ready(function(){
  $(".fab").on('click', openFAB);
  $("#overlay").on('click', closeFAB);
});