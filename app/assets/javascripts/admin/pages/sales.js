var $currentContactPriceList;
var search_contact = function(barcode_contact, id){
  $.ajax({
    type   : 'POST',
    url    : '/admin/sales/search_contact',
    data   : {barcode: barcode_contact, id: id},
    success: function (data) {
      var card_block = $(".discountCashBack");
      var btn_save = $("form.saveSale .bottomBlock .orderRequest");
      if (data != null){
        var purse = data.purse;
        card_block.find(".search_discount_card").val("На карте: " + purse + " руб.");
        card_block.find(".search_discount_card").attr("readonly", true);
        card_block.find("[name='contact_id']").val(data.id);
        card_block.find("[name='cashback_bank']").val(purse);
        $(".saveOrderRequest").css('display', 'inline-block');
        $currentContactPriceList = data.contact_prices
        setContactPriceToProductPrice();
        card_block.find(".deleteContactBtn").show();
        card_block.find(".contactAdd").hide();
        btn_save.removeClass("displayNone").show();
      }else{
        $(".saveOrderRequest").css('display', 'none');
        btn_save.hide();
        card_block.find(".deleteContactBtn").hide();
        card_block.find(".contactAdd").show();
        card_block.find(".search_discount_card").attr("readonly", false);
        card_block.find(".search_discount_card").val('');
        card_block.find("[name='cashback_bank']").val(0);
        card_block.find("[name='contact_id']").val("");
      }
    },
    error  : function () {
    }
  });
}

var backToProductsBlocks = function(){
  $(".leftContent .pasteBlock").fadeOut('slow', function() {
    $(".leftContent .allProducts").show();
    $(".js_backToProductsBlocks").hide();
    $(".leftContent .pasteBlock a").remove();
    $(".search_product_items").val('');
  });
}

var addProductItemToSale = function(id){
  ajaxApi("get", "/api/product_items/" + id, {}, function(result){
    var product_title = result.product_title;
    var title = result.title;
    var price = result.default_price;
    var type = $(".sales_page").data("type");
    if($(".rightContent .pricesChange").length){
      var find_price = parseFloat($(".pricesChange[data-id='"+ $("input[name='provider_id']").val() +"'] span[data-product_id='"+ result.product_id +"']").data("price"));
      if(find_price > 0){
        price = find_price;
      }
    }

    var find_item = $("form .allItemsSale .parentItemSale[data-id='" + id + "']");
    if (!find_item.length){
      find_item = $("form .copyBlockItemSale .parentItemSale").clone();
      find_item.find("[data-type='id']").attr("name", type + "[][item_id]").val(id);
      find_item.find("[data-type='price']").attr("name", type + "[][price]").val(price);
      find_item.find("[data-type='count']").attr("name", type + "[][count]");
      find_item.find("[data-type='title'] p").text(product_title + " - " + title);
      find_item.attr('data-id', id);
      $("form .allItemsSale").append(find_item);
      $(".tableCol5").scrollTop($(".tableCol5 .table-material").height());
    }
    if($(".js_openSearchProducts").is(":visible")){
      openSearchProducts();
    }
    price = find_item.find("input[name='"+ type +"[][price]']").val();
    var count_block = find_item.find("input[name='"+ type +"[][count]']");
    var count = parseInt(count_block.val()) + 1;
    count_block.val(count);
    find_item.find("[data-type='sum']").text(Math.round10((count * price), -1));
    calculateSale();
  }, false);
}

var loadProductItems = function(){
  var btn = $(this);
  var id = btn.data("id");
  $.get( "/admin/sales/load_content_product_items?id=" + id + "&count=" + $(".allProducts").data("type") + "&search=" + $(".search_product_items").val(), function(data) {
    $(".leftContent .pasteBlock a").remove();
    $(".content_sale .leftContent .pasteBlock").append(data);
    $(".leftContent .allProducts").fadeOut('slow', function() {
      $(".leftContent .pasteBlock").show();
      $(".js_backToProductsBlocks").show();
    });
    
  })
}

var addProductItemWhenBarcode = function(barcode){
  if($(".allProducts").length){
    ajaxApi("get", "/api/product_items/get_search", {barcode: barcode, type: $(".allProducts").data("type")}, function(result){
      if(result.ids.length){
        if(result.ids.length > 1){
          $("input.search_product_items").val(barcode);
          loadProductItems();
        }else{
          addProductItemToSale(result.ids[0]);
        }
      }else{
        show_error("Товар не найден или его сейчас нет на складе", 3000);
      }
    }, false);
  }
}

var changePriceOrCount = function(){
  var parentBlock = $(this).closest(".parentItemSale");
  var price = parseFloat(parentBlock.find("input[data-type='price']").val());
  var count = parseInt(parentBlock.find("input[data-type='count']").val());
  parentBlock.find("[data-type='sum']").text(Math.round10((count * price), -1));
  calculateSale();
}

var openPopupEndSale = function(){
  var block_popup = $("form.saveSale");
  var current_sum = parseFloat($("form.saleAllItemCashbox .bottomBlock .endSum .price").text());
  var curr_discaunt = parseFloat(block_popup.find(".sale_discount").val()) || 0;


  block_popup.find(".endSum .price").text(Math.round10((current_sum - curr_discaunt), -1));
  openFabPopup();
}

var calculateSale = function(){
  var sum = 0;
  $(".allItemsSale .parentItemSale [data-type='sum']").each(function(n, e){
    sum += parseFloat($(e).text());
  });
  $("form.saleAllItemCashbox .bottomBlock .sum .price").text(Math.round10(sum, -1));

  var count_postions = 0;
  $(".allItemsSale .parentItemSale [data-type='count']").each(function(n, e){
    count_postions += parseInt($(e).val());
  });
  $("form.saleAllItemCashbox .bottomBlock .countPositions .position").text(count_postions);
  if(count_postions > 0){
    $(".js_openPopupEndSale").attr('disabled', false);
  }else{
    $(".js_openPopupEndSale").attr('disabled', true);
  }
}

var sendOrSaveSale = function(){
  var method = "POST";
  var url = $("form.saleAllItemCashbox").attr("action");
  var valid_id = parseInt(String($(".sales_page").data("id"))) > 0
  if(valid_id){
    method = 'PUT';
    url = "/admin/sales/" + $(".sales_page").data("id");
  }
  $.ajax({
    url: url,
    type: method,
    data: dataAllFormSale(),
    success: function(data) {
      var order_request_id = $("input[name='order_request']").val();
      $(".js_gotToCheck").data("id", data.model.id);
      if(order_request_id.length){
        history.pushState({}, null, "/admin/sales/new");
      }
      if(valid_id){
        $(".sales_page").data("id", "");
      }
      animationEndSale();
    }
  });
}

var clearReceivedCash = function(){
  $(".received_cash").val(''); 
  $(".received_cash").prop('disabled', false);
  $(".received_cash + .clearInput").hide();
}

var clearSale = function(type){
  backToProductsBlocks();
  if(type != "proceed"){
    var type_page = $(".sales_page").data("type");
    $("form.saleAllItemCashbox .allItemsSale .parentItemSale").remove();
    $("form .sale_discount").val("");
    search_contact("");
    clearReceivedCash();
    calculateSale();
    history.pushState({}, null, "/admin/"+ type_page +"/new");
    $("input[name='order_request']").val("");
  }
  $(".endSaleContent").hide();
  $(".fab.active.full-screen").addClass("displayNone").removeClass("full-screen");
  closeAllOtherPopup();
}

var animationEndSale = function(type){
  var popup = $(".fab");
  var endBlcok = $(".endSaleContent")
  popup.find(".conteinerPopup").hide();
  popup.find(".fab-hdr").hide();
  popup.addClass("full-screen");
  if (type == "orderRequest") {
    endBlcok.find(".title.orderSale").addClass("displayNone");
    endBlcok.find(".title.orderRequest").removeClass("displayNone");
    endBlcok.find(".buttonGroup .js_gotToCheck").addClass("displayNone");
    endBlcok.find(".buttonGroup .js_proceedEdit").removeClass("displayNone");
  } else {
    endBlcok.find(".title.orderSale").removeClass("displayNone");
    endBlcok.find(".title.orderRequest").addClass("displayNone");
    endBlcok.find(".buttonGroup .js_gotToCheck").removeClass("displayNone");
    endBlcok.find(".buttonGroup .js_proceedEdit").addClass("displayNone");
  }
  setTimeout(function(){
    endBlcok.hide().removeClass("displayNone").fadeIn('slow');
  }, 100);
}

var gotToCheck = function(){
  window.open('/admin/sales/'+ $(this).data("id") +'.pdf','_blank');
}

var dataAllFormSale = function(){
  var data_sale = $("form.saleAllItemCashbox").serializeArray();
  var data_contact = $("form.discountContact").serializeArray();
  var data_formation = $("form.saveSale").serializeArray();
  var data_form = data_sale.concat(data_contact).concat(data_formation).concat([{name: "typeAction", value: "json"}]);
  return data_form;
}

var saveOrderRequest = function(){
  $.ajax({
    type   : 'POST',
    url    : '/admin/sales/save_order_request',
    data   : dataAllFormSale(),
    success: function (data) {
      history.pushState({}, null, "/admin/sales/new?order_request=" + data.id);
      $(".idOrderRequest").val(data.id);
      $("input[name='order_request']").val(data.id);
      animationEndSale('orderRequest');
    },
    error  : function () {
      show_error("Ошибка", 3000);
    }
  });
}

var openSearchProducts = function(){
  $(".rightContent, .leftContent").toggleClass("mobileDisplayNone");
}

var addContactPopup = function(){
  openAllOtherPopup("Добавление нового контакта", function(){
    $.ajax({
      type: 'GET',
      url: '/admin/contacts/new?typeAction=json',
      success: function (data){
        var content_popup = $(".allOtherPopup .conteinerPopup");
        content_popup.html(data);
        var form_contact = content_popup.find("form");
        content_popup.find("button[type=submit]").click(function(e){
          e.preventDefault();
          var name = form_contact.find("input[name='contacts[first_name]']");
          var email = form_contact.find("input[name='contacts[email]']");
          var phone = form_contact.find("input[name='contacts[phone]']");
          if (name.length && email.length && phone.length){
            $.ajax({
              type: "POST",
              url: '/admin/contacts?typeAction=json',
              data: form_contact.serialize(),
              success: function(data){
                search_contact(null, data.id);
                $("#overlay").click();
                $(".userContact .contactAdd").hide();
              }
            });
          }
        });
      }
    })
  })
}

var ajax_current_price_delivery = function(current_price){
  ajaxApi("get", "/api/api/current_price_delivery", {current_price: current_price}, function(result){
    $(".saleAllItemCashbox .delivery .price").text(result.current_price_delivery + " руб.");
    if (result.current_price_delivery > 0){
      $(".saleAllItemCashbox .delivery").show();
    }else{
      $(".saleAllItemCashbox .delivery").hide();
    }
  }, false);
}

var installPusher = function(){
  var channel = pusher.subscribe('enlistment');
  console.log("start pusher");
  channel.bind('sms_info', function(data) {
    var sum_sale = parseInt($(".moneyClacl .titlePrice").text());
    console.log(data);
    if( $("input[name='cashbox_type']").val() == "visa" && current_user_magazine_id() == data.magazine_id){
      show_error(data.message, 3000);
    }
  });
}

$(document).ready(function(){
  $(document).on('click', '.js_loadProductItems[data-model="ProductItem"]', function(){
    addProductItemToSale($(this).data('id'));
  });
  $(document).on('click', '.js_loadProductItems[data-model="Product"]', loadProductItems);
  
  $(document).on('click', '.js_backToProductsBlocks', backToProductsBlocks);

  $(document).on('click', '.js_openPopupEndSale', openPopupEndSale); 

  $(document).on('click', '.js_submitSale', sendOrSaveSale);

  $(document).on('click', '.js_clearSale', clearSale);

  $(document).on('click', '.js_gotToCheck', gotToCheck);

  $(document).on('click', '.js_openSearchProducts', openSearchProducts);

  $(document).on('click', '.js_proceedEdit', function(){
    clearSale("proceed");
  });

  $(document).on('click', '.contactAdd', addContactPopup);

  scanBarCode(function(barcode){
    if ($(".search_discount_card").is(':focus')){
      search_contact(barcode);
    }else{
      addProductItemWhenBarcode(barcode);
    }
  });

  $(document).on('click', '.deleteContactBtn', function(){
    search_contact("");
  });

  $(document).on('click', '.js_saveSaleToOrderRequest', saveOrderRequest);

  $(document).on("click", ".received_cash + .clearInput", clearReceivedCash);

  $(document).on('change', 'form.saveSale .received_cash', function(){
    var result = parseFloat($("form.saveSale .endSum .price").text());
    $(this).prop('disabled', true);
    $(".received_cash + .clearInput").show();
    $(".titleDelivery").val("Cдача " + ($(this).val() - result) + " руб.");
  });

  $(document).on('change', 'form.saleAllItemCashbox .parentItemSale input', changePriceOrCount);

  $(document).on('change', 'form.saveSale input.sale_discount', openPopupEndSale);

  $(document).on('click', '.parentItemSale .deleteItemSale', function(){
    $(this).closest(".parentItemSale").remove();
    calculateSale();
  });

  var timout_search_keyup = ""
  $(document).on('keyup', '.search_discount_card', function(){
    clearTimeout(timout_search_keyup);
    var input = $(this);
    if(input.val().length > 0){
      timout_search_keyup = setTimeout(function(){
        ajaxApi("get", "/api/contacts/search", {search: input.val()}, function(result){
          var list_search = input.closest(".userContact").find(".findContact");
          list_search.find("li").remove();
          if (result.length > 0){
            list_search.show();
            $.each(result, function(n, r){
              list_search.append($("<li data-id="+ r.id +">" + r.first_name + "</li>"));
            });
            list_search.find("li").on('click', function(){
              search_contact(null, $(this).data('id'));
              list_search.hide();
            })
          }else{
            list_search.hide();
          }
        }, false);
      }, 300);
    }else{
      search_contact("");
      $(".allItemsSale .saleProductIdSelect[data-price='change']").attr('data-price', 'not_change');
    }
  });

  var timout_search_product_items;
  $(document).on('keyup', '.search_product_items', function(){
    clearTimeout(timout_search_product_items);
    var input = $(this);
    if(input.val().length > 0){
      timout_search_product_items = setTimeout(loadProductItems(), 300);
    }else{
      if($(".leftContent .pasteBlock a").length){
        backToProductsBlocks();
      }
    }
  });


  if($("input[name='contact_id']").data('id') != undefined){
    search_contact(null, $("input[name='contact_id']").data('id'));
  }

  calculateSale();
  installPusher();
});