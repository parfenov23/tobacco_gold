$(document).ready(function(){
  include_mad_select($(".stockHeader .mad-select").removeClass("noInit"), function(input){
    window.location.assign(window.location.pathname + "?magazine_id=" + input.val());
  });
  if($(".well[data-action='admin/stock']").length){
    scanBarCode(function(barcode){
      if ($("input[name='serach']").is(':focus')){
        var title = "Поиск описания";
        var url = "/api/product_items/get_search?api_key=" + current_user_api_key() + "&barcode=" + barcode;
        console.log(barcode)
        loadContentInOtherPopup(title, url);
      }
    })  
  }
})