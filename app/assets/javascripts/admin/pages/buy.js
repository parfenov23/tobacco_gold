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

$(document).ready(function(){
  $(document).on('click', '.js_saveNewProductItem', saveNewProductItem);
});