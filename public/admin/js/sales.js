var loadContent = function (type, id, end_func = function(){}) {
  var get_product_items = function(){
    var url = new URL(window.location.href)
    var type_sale = url.searchParams.get("type_sale") || ""
    $.get( "/admin/sales/load_content_product_items?"+ type +"=" + id + "&type_sale=" + type_sale, function(data) {
      $("#contentSelect").append(data);
      end_func();
    })
  }

  if (type == "id"){
    if( !$("#contentSelect").find("#select" + id ).length) {
      get_product_items();
    }else{
      end_func();
    }
  }else{
    if(!$("#contentSelect li[data-barcode='"+ id +"']").length){
      get_product_items();
    }else{
      end_func();
    }
  }


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
    loadContent("barcode", barcode, function(){
      var item = $("#contentSelect li[data-barcode='"+ barcode +"']");
      if (item.length){
        addBlankBlockItem(barcode);
        var productSaleBlock = $(".barcode" + barcode + ":last");
        var product_select = productSaleBlock.find(".changeSelectContent");
        var product_id = item.data('product');
        product_select.val(product_id);
        selectedLi(product_select.closest(".mad-select"), product_id);
        addProductItemToProductBlock(product_select, product_id);
        var block_item = productSaleBlock.find(".changeSelectContent[name='sales[][item_id]']")
        selectedLi(block_item.closest(".mad-select"), item.data("value"));
        findItem = $(".allItemsSale .parentItemSale.barcode" + barcode);
        findItem.addClass("createFromBarcodeScan");
        changeSelectProductItem(findItem.find(".changeSelectProductItem"));
        sumItemSale(findItem);
        priceItemSale();
      }

    })

  }else{
    var input_count = findItem.find("input[name='sales[][count]']");
    input_count.val( parseInt(input_count.val()) + 1 );
    priceItemSale();
    sumItemSale(findItem);
  }
}

var addBlankBlockItem = function(bc){
  var refer = $($(".referenceItemSale tbody").html());

  include_mad_select($(refer).find(".mad-select").removeClass("noInit"), function(input){
    var bl_val = parseInt(input.val());
    addProductItemToProductBlock(input, bl_val);
  });
  $(".allItemsSale").append($(refer).addClass('barcode' + bc));
  $(document).scrollTop($(document).height());
  changeSelectPriceAndCount();
}

var addProductItemToProductBlock = function(curr_block, bl_val){
  loadContent("id", bl_val, function() {
    var id = "#select" + bl_val;
    var block_content = $("#contentSelect " + id).html();
    if (bl_val > 0){
      var load_content_selests = $("<div>"+ block_content + "</div>");
      $(curr_block).closest('.parentItemSale').find('.formLoadContentTaste').html(load_content_selests.find(".selectProductItem"));
      $(curr_block).closest('.parentItemSale').find('.formLoadContentPrice').html(load_content_selests.find(".selectProductPrice"));
    } else {
      $(curr_block).closest('.parentItemSale').find('.formLoadContentTaste').html('');
      $(curr_block).closest('.parentItemSale').find('.formLoadContentPrice').html('');
    }
    var priceSelect = $(curr_block).closest(".parentItemSale").find(".formLoadContentPrice").find(".mad-select").removeClass("noInit");
    var productItemSelect = $(curr_block).closest(".parentItemSale").find(".formLoadContentTaste").find(".mad-select").removeClass("noInit");
    include_mad_select(productItemSelect, function(block){
      changeSelectProductItem(block);
    });
    include_mad_select(priceSelect);
    changeSelectProductItem(productItemSelect.find("input"));
    priceItemSale();
  });
}

var priceItemSale = function(){
  var all_select_ptice = $(".selectProductPrice .mad-select-drop .selected");
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
  var curr_price = parseInt(block.find(".selectProductPrice .mad-select-drop .selected").text());
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

var installPusher = function(){
  var channel = pusher.subscribe('enlistment');
  channel.bind('sms_info', function(data) {
    var sum_sale = parseInt($(".moneyClacl .titlePrice").text());
    if( $("input[name='cashbox_type']").val() == "visa" && data.sum == sum_sale && current_user_magazine_id() == data.magazine_id){
      show_error(data.message, 3000);
    }
  });
}

var changeSelectProductItem = function(select){
  var block_select = $(select).closest(".mad-select").find(".mad-select-drop .selected");
  var price = block_select.data("price_id");
  var selectPrice = $(select).closest(".parentItemSale").find(".selectPrice");
  var block_select_price = $(select).closest(".parentItemSale").find(".formLoadContentPrice .mad-select");
  if (price != undefined) {
    selectedLi(block_select_price, price);
  } else {
    selectedLi(block_select_price, block_select.data("deff_price"));
  }
}

$(document).ready(function(){
  scanBarCode();
  installPusher();
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