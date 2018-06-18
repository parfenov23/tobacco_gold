var saveNewProductItem = function(){
  var data = $("form.newTasteItem").serialize();
  $.ajax({
    type: 'POST',
    url : '/admin/buy/new_item_product',
    data: data
  }).success(function (data) {
    $("#contentSelect").html($(data));
    $(".addFormNewItem").hide();
    $("form.newTasteItem input").val('');
    $("#overlay").click();
  }).error(function (data) {
  });
};

var allProductCalc = function(){
  var all_product = {}
  $(".allProductCalc .referencePaste").remove();
  $(".allItemsSale .parentItemSale").each(function(n, e){
    var product = $(e).find(".inlineBlock .mad-select .selected:first").text();
    var count = parseInt($(e).find(".countItems").val());
    var price = parseInt($(e).find(".selectProductPrice").val());
    var curr_block = all_product[product];
    if (curr_block == undefined){
      all_product[product] = {count: count, price: [price], sum: (count*price)}
    }else{
      curr_block.count = curr_block.count + count;
      curr_block.price.push(price);
      curr_block.sum = curr_block.sum + (count*price)
    }
  });
  for (var key in all_product) {
    var referenceCopy = $(".allProductCalc .referenceCopy").clone();
    var curr_hb = all_product[key];
    referenceCopy.find(".product").text(key);
    referenceCopy.find(".count").text(curr_hb.count);

    var sum_price = curr_hb.price.reduce(function(previousValue, currentValue, index, array) {
      return previousValue + currentValue;
    });
    var text_price = sum_price/curr_hb.price.length;
    referenceCopy.find(".price").text(text_price);
    referenceCopy.find(".sum").text(curr_hb.sum);
    referenceCopy.show();
    referenceCopy.removeClass("referenceCopy").addClass("referencePaste");
    $(".allProductCalc tbody").append(referenceCopy);
  }
}

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
  if($("form[action='/admin/buy']").length){
    scanBarCode(function(barcode){
      addItemWhenBarcodeScan(barcode);
    });

    $(document).on('click', '.addItemSale', addBlankBlockItem);

    $(document).on('change', '.changeSelectContent', function () {
      var bl_val = parseInt(this.value);
      addProductItemToProductBlock(this, bl_val);
    });

    $(document).on('click', '.priceItemSale', function(){
      priceItemSale();
      $(".allProductCalc").show();
      allProductCalc();
    });

    changeSelectPriceAndCount();

    $(document).on('click', '.js_saveNewProductItem', saveNewProductItem);

    $(document).on('click', '.deleteItemSale', function(){
      $(this).closest(".parentItemSale").remove();
    });
  }

  $(".mad-select.initSelectBuySearch").each(function(i, e){
    $(e).removeClass("noInit")
    include_mad_select($(e), function(block){
      initSelectBuySearch(block);
    });
  })
})