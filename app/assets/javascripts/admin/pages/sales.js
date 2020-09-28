var loadContent = function (type, id, end_func) {
  if (end_func == undefined) end_func = function(){};
  var get_product_items = function(){
    var url = new URL(window.location.href)
    var type_sale = url.searchParams.get("type_sale") || ""
    $.get( "/admin/sales/load_content_product_items?"+ type +"=" + id + "&type_sale=" + type_sale, function(data) {
      if (data.length){
        $("#contentSelect").append(data);
        end_func();
      }else{
        if (!$(".discountCashBack input[name='contact_id']").val().length){
          if (type == "barcode") search_contact(id);
        }
        
      }

    })
  }


  if( !$("#contentSelect").find("#select" + id ).length && !$("#contentSelect li[data-barcode='"+ id +"']").length ) {
    get_product_items();
  }else{
    end_func();
  }


};

var autoAddItem = function(type, id){
  loadContent(type, id, function(){
    if(type == "barcode"){
      var item = $("#contentSelect li[data-barcode='"+ id +"']");
    }else{
      var item = $("#contentSelect li[data-value='"+ id +"']");
    }
    
    if (item.length){
      addBlankBlockItem(id);
      var productSaleBlock = $(".barcode" + id + ":last");
      var product_select = productSaleBlock.find(".changeSelectContent");
      var product_id = item.data('product');
      product_select.val(product_id);
      selectedLi(product_select.closest(".parentSelectMd"), product_id);
      addProductItemToProductBlock(product_select, product_id);
      var block_item = productSaleBlock.find(".selectProductItem .changeSelectContent")
      selectedLi(block_item.closest(".parentSelectMd"), item.data("value"));
      findItem = $(".allItemsSale .parentItemSale.barcode" + id);
      // findItem.addClass("createFromBarcodeScan");
      findItem.find("td.barcode span").text(id);
      changeSelectProductItem(findItem.find(".changeSelectProductItem"));
      if(type == "barcode") findItem.find("input[name='buy[][barcode]']").val(id);
      sumItemSale(findItem);
    }
  });
}

var addItemWhenBarcodeScan = function(barcode){
  var findItem = $(".allItemsSale .parentItemSale.barcode" + barcode);
  if (!findItem.length){
    autoAddItem('barcode', barcode);

  }else{
    var input_count = block_or_block(findItem.find("input[name='sales[][count]']"), findItem.find("input.countItems"));
    input_count.val( parseInt(input_count.val()) + 1 );
    sumItemSale(findItem);
  }
}

var addBlankBlockItem = function(bc){

  var refer = $($(".referenceItemSale").html());

  include_mad_select($(refer).find(".parentSelectMd").removeClass("noInit"), function(input){
    var bl_val = parseInt(input.val());
    console.log(input);
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
      var parent_item = $(curr_block).closest('.parentItemSale');
      if (parent_item.length){
        var price = $(curr_block).closest(".parentSelectMd").find(".selected").data('price');
        var input_price =  parent_item.find("input.selectProductPrice");
        if (input_price.length) input_price.val(price);
      }
    } else {
      $(curr_block).closest('.parentItemSale').find('.formLoadContentTaste').html('');
      $(curr_block).closest('.parentItemSale').find('.formLoadContentPrice').html('');
    }
    var priceSelect = block_or_block($(curr_block).closest(".parentItemSale").find(".formLoadContentPrice .parentSelectMd").removeClass("noInit"), 
      $(curr_block).closest(".parentItemSale").find(".formLoadContentPrice input.selectProductPrice"));
    var productItemSelect = $(curr_block).closest(".parentItemSale").find(".formLoadContentTaste .parentSelectMd").removeClass("noInit");
    include_mad_select(productItemSelect, function(block){
      changeSelectProductItem(block);
      sumItemSale($(block).closest(".parentItemSale"));
    });
    if (priceSelect.prop("tagName") != "INPUT"){
      include_mad_select(priceSelect, function(block){
        sumItemSale($(block).closest(".parentItemSale"));
      });
    }else{
      $(priceSelect).on('change', function(){
        sumItemSale( $(this).closest(".parentItemSale") );
      });
    }

    changeSelectProductItem(productItemSelect.find("input"));

    sumItemSale($(curr_block).closest(".parentItemSale"));
  });
}

var priceItemSale = function(){
  var result = 0;
  $(".endSumPosition:visible").each(function(n, block){ result+= parseFloat($(block).text())});
  var discountBlock = $(".discountCashBack");
  var cashback_type = discountBlock.find("[name='cashback_type']").val();
  var cashback_bank = parseFloat(discountBlock.find("[name='cashback_bank']").val());
  var sale_discount = $(".saleDiscount .sale_discount");
  var sale_discount_val = parseFloat(sale_discount.val());


  if(sale_discount_val > 0){
    var type_sale_disc = sale_discount.closest(".saleDiscount").find("input[name='sale_disckount_select']").val();
    if (type_sale_disc == "rub"){
      result -= sale_discount_val;
    }
    if (type_sale_disc == "proc"){
      result -= (result/100*sale_discount_val);
    }
  }
  var time_timeout = 0;
  if (window.location.href.search("order_request") > 0){
    ajax_current_price_delivery(result);
    time_timeout = 200;
  }
  
  setTimeout(function(){
    result += parseInt($(".saleAllItemCashbox .delivery .price").text());
    $(".titlePrice").text(result.toFixed(1));
    if ($(".received_cash").length && $(".received_cash").val().length && !$(".received_cash").prop('disabled')){
      $(".received_cash").prop('disabled', true);
      $(".received_cash + .clearInput").show();
      $(".titleDelivery").val("Cдача " + ($(".received_cash").val() - result) + " руб.");
    }
  }, time_timeout);

}

var sumItemSale = function(block){
  var curr_block = block_or_block(block.find(".selectProductPrice .listSelectMd .selected"), 
    block.find(".selectProductPrice"));
  var curr_price = parseFloat(block_or_block( curr_block.text(), curr_block.val() ) );
  // var curr_count = parseInt(block_or_block(block.find("[name='sales[][count]']"), 
  //   block.find("[name='buy[][count]']")).val());
  var curr_count = parseFloat(block.find("input.countItems").val());
  block.find(".endSumPosition").text((curr_price*curr_count).toFixed(1));
  priceItemSale();
}


var changeSelectPriceAndCount = function(){
  $(document).on('change', '.selectPrice, .countItems', function () {
    var block = $(this).closest(".parentItemSale");
    sumItemSale(block);
  });
}

var setContactPriceToProductPrice = function(){
  if ($currentContactPriceList != undefined && $currentContactPriceList.length){
    $(".allItemsSale .saleProductIdSelect[data-price='not_change']").each(function(i, block){
      var product_id = $(block).val();
      var find_contact_price = $.grep($currentContactPriceList, function(e){ return e.product_id == product_id; })
      if (find_contact_price.length){
        selectedLi($(block).closest(".parentItemSale").find(".selectProductPrice"), find_contact_price[0].product_price_id);
        $(block).attr('data-price', 'change');
      }
    })
  }
}

var changeSelectProductItem = function(select){
  var block_select = $(select).closest(".parentSelectMd").find(".listSelectMd .selected");
  var price = block_select.data("price_id");
  var selectPrice = $(select).closest(".parentItemSale").find(".selectPrice");
  var block_select_price = $(select).closest(".parentItemSale").find(".formLoadContentPrice .parentSelectMd");
  if (price != undefined) {
    selectedLi(block_select_price, price);
  } else {
    selectedLi(block_select_price, block_select.data("deff_price"));
  }
  var block_product_select = block_select.closest(".parentItemSale").find(".saleProductIdSelect");
  if(block_product_select.attr("data-price") == "change") {
    block_product_select.attr("data-price", "not_change");
  }
  setContactPriceToProductPrice();
}



