var saveNewProductItem = function(){
  var data = $("form.newTasteItem").serialize();
  $.ajax({
    type: 'POST',
    url : '/admin/buy/new_item_product',
    data: data
  }).success(function (data) {
    $("#contentSelect").html($(data));
    $(".addFormNewItem").hide();
    $("form.newTasteItem input[name='buy[title]']").val('');
    $("#overlay").click();
    var product_id = $("form.newTasteItem input[name='buy[product_id]']").val();
    var arr = [];
    $("#contentSelect #select" +  product_id + " .listSelectMd ul li").each(function(n, e){arr.push($(e).data("value"))});
    autoAddItem('product_item_id', Math.max.apply(Math, arr));
  }).error(function (data) {
  });
};

$(document).ready(function(){
  $(document).on('click', '.js_saveNewProductItem', saveNewProductItem);
});