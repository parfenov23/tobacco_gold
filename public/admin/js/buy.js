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
  var item = $("#contentSelect option[data-barcode='"+ barcode +"']");
  if (item.length){
    addBlankBlockItem(barcode);
    var productSaleBlock = $(".barcode" + barcode + ":last");
    var product_select = productSaleBlock.find("select.changeSelectContent");
    var product_id = item.data('product')
    product_select.val(product_id);
    addProductItemToProductBlock(product_select, product_id);
    productSaleBlock.find("select[name='buy[][item_id]']").val(item.val());
    productSaleBlock.find("input[name='buy[][barcode]']").hide();
    priceItemSale();
  }
}


var addBlankBlockItem = function(bc){
  var refer = $(".referenceItemSale").html();
  $(".allItemsSale").append($(refer).addClass('barcode' + bc));
  $(document).scrollTop($(document).height());
}

var addProductItemToProductBlock = function(curr_block, bl_val){
  var id = "#select" + bl_val;
  var block_content = $("#contentSelect " + id).html();
  var price = $(curr_block).find("option[value='" + bl_val + "']").data('price');
  var parent_item = $(curr_block).closest('.parentItemSale')
  if (bl_val > 0){
    parent_item.find('.formLoadContent').html($(block_content));
    parent_item.find("input[name='buy[][price_id]']").val(price)
  } else {
    parent_item.find('.formLoadContent').html('');
  }
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
}

$(document).ready(function(){
  scanBarCode();

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