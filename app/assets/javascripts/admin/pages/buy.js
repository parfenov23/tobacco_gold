var saveNewProductItem = function(){
  var data = $("form.newTasteItem").serialize();
  $.ajax({
    type: 'POST',
    url : '/admin/buy/new_item_product',
    data: data
  }).success(function (data) {
    $(".addFormNewItem").hide();
    $("form.newTasteItem input[name='buy[title]']").val('');
    $("#overlay").click();
    addProductItemToSale(data.model.id);

  }).error(function (data) {
  });
};

var initSelectBuySearch = function(block){
  var parent_block = $(block).closest(".currentItem");
  var product_item_id = $(block).val();
  var title = parent_block.find(".title").data("title");
  $.ajax({
    type: 'POST',
    url : '/admin/buy/search_result_update',
    data: {product_item_id: product_item_id, title: title}
  }).success(function (data) {
    parent_block.removeClass("info").removeClass("success").removeClass("danger");
    if (data.count > 0) { 
      parent_block.addClass("success"); 
    }else{
      parent_block.addClass("info"); 
    } 
    parent_block.find(".current_count").text(data.count);
  }).error(function (data) {});
}

$(document).ready(function(){
  $(document).on('click', '.js_saveNewProductItem', saveNewProductItem);

  $(".parentSelectMd.initSelectBuySearch").each(function(i, e){
    $(e).removeClass("noInit")
    include_mad_select($(e), function(block){
      initSelectBuySearch(block);
    });
  })
});