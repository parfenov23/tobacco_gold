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
  }).error(function (data) {
  });
};

var scanBarCode = function(){
  var pressed = false; 
  var chars = []; 
  $(window).keypress(function(e) {
    if (e.which >= 48 && e.which <= 57) {
      chars.push(String.fromCharCode(e.which));
    }
    // console.log(e.which + ":" + chars.join("|"));
    if (pressed == false) {
      setTimeout(function(){
                // check we have a long length e.g. it is a barcode
                if (chars.length >= 10) {
                  var barcode = chars.join("");
                  // console.log("Barcode Scanned: " + barcode);
                  addItemWhenBarcodeScan(barcode);
                }
                chars = [];
                pressed = false;
              },500);
    }
    pressed = true;
  });
}

var addItemWhenBarcodeScan = function(barcode){
  var findItem = $(".allItemsSale .parentItemSale.barcode" + barcode);
  if (!findItem.length){
    var item = $("#contentSelect option[data-barcode='"+ barcode +"']");
    if (item.length){
      addBlankBlockItem(barcode);
      var productSaleBlock = $(".barcode" + barcode + ":last");
      var product_select = productSaleBlock.find("select.changeSelectContent");
      var product_id = item.data('product')
      product_select.val(product_id);
      addProductItemToProductBlock(product_select, product_id);
      productSaleBlock.find("select[name='buy[][item_id]']").val(item.val());
      findItem = $(".allItemsSale .parentItemSale.barcode" + barcode);
      findItem.addClass("createFromBarcodeScan");
      findItem.find("td.barcode span").text(barcode);
      sumItemSale(findItem);
      priceItemSale();
    }
  }else{
    var input_count = findItem.find("input[name='buy[][count]']");
    input_count.val( parseInt(input_count.val()) + 1 );
    priceItemSale();
    sumItemSale(findItem);
  }
}


var addBlankBlockItem = function(bc){
  var refer = $(".referenceItemSale tbody").html();
  $(".allItemsSale").append($(refer).addClass('barcode' + bc));
  $(document).scrollTop($(document).height());
}

var addProductItemToProductBlock = function(curr_block, bl_val){
  var id = "#select" + bl_val;
  var block_content = $("#contentSelect " + id).html();
  var price = $(curr_block).find("option[value='" + bl_val + "']").data('price');
  var parent_item = $(curr_block).closest('.parentItemSale')
  if (bl_val > 0){
    var load_content_selests = $("<div>"+ block_content + "</div>");
    // parent_item.find('.formLoadContent').html($(block_content));
    $(curr_block).closest('.parentItemSale').find('.formLoadContentTaste').html(load_content_selests.find("select[name='buy[][item_id]']"));
    $(curr_block).closest('.parentItemSale').find('.formLoadContentPrice').html(load_content_selests.find("input[name='buy[][price_id]']"));
    parent_item.find("input[name='buy[][price_id]']").val(price);
    changeSelectPriceAndCount();
  } else {
    parent_item.find('.formLoadContent').html('');
  }
  priceItemSale();
}

var priceItemSale = function(){
  var all_select_ptice = $(".selectPrice:visible");
  var result = 0;
  all_select_ptice.each(function(i, block){
    var price = parseInt($(block).val());
    var parent_block = $(block).closest(".parentItemSale");
    var count = parseInt(parent_block.find(".countItems").val());
    result += price*count;
  });
  $(".titlePrice").text(result);
  $(".parentItemSale").each(function(n, e){
    sumItemSale($(e));
  });
  allProductCalc();
}

var sumItemSale = function(block){
  var curr_price = parseInt(block.find("[name='buy[][price_id]']").val());
  var curr_count = parseInt(block.find("[name='buy[][count]']").val());
  block.find(".endSumPosition").text(curr_price*curr_count);
}

var changeSelectPriceAndCount = function(){
  $(document).on('change', '.selectPrice, .countItems', function () {
    var block = $(this).closest(".parentItemSale");
    sumItemSale(block);
    priceItemSale();
  });
}

var allProductCalc = function(){
  var all_product = {}
  $(".allProductCalc .referencePaste").remove();
  $(".allItemsSale tr").each(function(n, e){
    var product = $(e).find(".inlineBlock select option:selected").text();
    var count = parseInt($(e).find(".countItems").val());
    var price = parseInt($(e).find(".selectPrice").val());
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

$(document).ready(function(){
  scanBarCode();
  changeSelectPriceAndCount();

  $(document).on('click', '.addItemSale', addBlankBlockItem);
  
  $(document).on('click', '.deleteItemSale', function(){
    $(this).closest(".parentItemSale").remove();
  });

  $(document).on('change', '.changeSelectContent', function () {
    var bl_val = parseInt(this.value);
    addProductItemToProductBlock(this, bl_val);
  });

  $(document).on('click', '.priceItemSale', priceItemSale);

  $(document).on('click', '.js_saveNewProductItem', saveNewProductItem);
  $(document).on('click', '.js_openFormNewItem', function(){
    $(".addFormNewItem").show();
  });
  $(document).on('click', '.js_hideFormNewItem', function(){
    $(".addFormNewItem").hide();
  });

  $(window).keydown(function(event){
    if(event.keyCode == 13) {
      event.preventDefault();
      return false;
    }
  });
});