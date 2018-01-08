var loadContent = function (block) {

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
                  if ($(".search_discount_card").is(':focus')){
                    search_contact($(".search_discount_card"));
                  }else{
                    addItemWhenBarcodeScan(barcode);
                  }
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
      productSaleBlock.find("select[name='sales[][item_id]']").val(item.val());
      findItem = $(".allItemsSale .parentItemSale.barcode" + barcode);
      changeSelectProductItem(findItem.find(".changeSelectProductItem"));
      sumItemSale(findItem);
      priceItemSale();
    }
  }else{
    var input_count = findItem.find("input[name='sales[][count]']");
    input_count.val( parseInt(input_count.val()) + 1 );
    priceItemSale();
    sumItemSale(findItem);
  }
}

var addBlankBlockItem = function(bc){
  var refer = $(".referenceItemSale tbody").html();
  $(".allItemsSale").append($(refer).addClass('barcode' + bc));
  $(document).scrollTop($(document).height());
  changeSelectPriceAndCount();
}

var addProductItemToProductBlock = function(curr_block, bl_val){
  var id = "#select" + bl_val;
  var block_content = $("#contentSelect " + id).html();
  if (bl_val > 0){
    var load_content_selests = $("<div>"+ block_content + "</div>");
    $(curr_block).closest('.parentItemSale').find('.formLoadContentTaste').html(load_content_selests.find("select[name='sales[][item_id]']"));
    $(curr_block).closest('.parentItemSale').find('.formLoadContentPrice').html(load_content_selests.find("select[name='sales[][price_id]']"));
  } else {
    $(curr_block).closest('.parentItemSale').find('.formLoadContentTaste').html('');
    $(curr_block).closest('.parentItemSale').find('.formLoadContentPrice').html('');
  }
  priceItemSale();
}

var priceItemSale = function(){
  var all_select_ptice = $(".selectPrice:visible option:selected");
  var result = 0;
  all_select_ptice.each(function(i, block){
    var price = parseInt($(block).text());
    var parent_block = $(block).closest(".parentItemSale");
    var count = parseInt(parent_block.find(".countItems").val());
    result += price*count;
  });
  var discountBlock = $(".discountCashBack");
  var cashback_type = discountBlock.find("[name='cashback_type']").val();
  var cashback_bank = parseInt(discountBlock.find("[name='cashback_bank']").val());
  if (cashback_type == "dickount"){
    if (result >= cashback_bank){
      result -= cashback_bank
    }else{
      result = 0
    }
  }
  $(".titlePrice").text(result);
  if ($(".received_cash").val().length){
    $(".titleDelivery").text("сдача: " + ($(".received_cash").val() - result) );
    $(".titleDelivery").show();
  }
  $(".parentItemSale").each(function(n, e){
    sumItemSale($(e));
  })
}

var sumItemSale = function(block){
  var curr_price = parseInt(block.find("[name='sales[][price_id]'] option:selected").text());
  var curr_count = parseInt(block.find("[name='sales[][count]']").val());
  block.find(".endSumPosition").text(curr_price*curr_count);
}


var changeSelectPriceAndCount = function(){
  $(document).on('change', '.selectPrice, .countItems', function () {
    var block = $(this).closest(".parentItemSale");
    sumItemSale(block);
    priceItemSale();
  });
}

var search_contact = function(input){
  var barcode_contact = $(input).val();
  $.ajax({
    type   : 'POST',
    url    : '/admin/sales/search_contact',
    data   : {barcode: barcode_contact},
    success: function (data) {
      var card_block = $(".discountCashBack");
      if (data != null){
        var purse = data.purse;
        card_block.find(".search_discount_card").val("На карте: " + purse + " руб.");
        card_block.find("[name='contact_id']").val(data.id);
        card_block.find("[name='cashback_bank']").val(purse);
        if (purse >= 5){
          card_block.find("[name='cashback_type']").show();
        }else{
          card_block.find("[name='cashback_type']").hide().find("[value='stash']").attr('selected', 'true');
        }
      }else{
        card_block.find("[name='cashback_bank']").val(0);
        card_block.find("[name='contact_id']").val("");
        card_block.find("[name='cashback_type']").hide().find("[value='stash']").attr('selected', 'true');
      }
    },
    error  : function () {
    }
  });
}

var changeSelectProductItem = function(select){
  var price = $(select).find("option:selected").data("price_id");
  var selectPrice = $(select).closest(".parentItemSale").find(".selectPrice");
  if (price != undefined){
    selectPrice.val(price);
  }else{
    selectPrice.val(selectPrice.data("deff_price"));
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

  $(document).on('change', '.changeSelectProductItem', function () {
    changeSelectProductItem(this);
  });

  $(document).on('change', '.search_discount_card', function () {
    if(!$(this).val().length){
      search_contact(this);
    }
  });

  $(document).on('click', '.priceItemSale', priceItemSale);

  $(window).keydown(function(event){
    if(event.keyCode == 13) {
      event.preventDefault();
      return false;
    }
  });


});