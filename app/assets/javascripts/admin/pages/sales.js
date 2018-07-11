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


  if( !$("#contentSelect").find("#select" + id ).length && !$("#contentSelect li[data-barcode='"+ id +"']").length && !$("#contentSelect li[data-value='"+ id +"']").length) {
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
      selectedLi(product_select.closest(".mad-select"), product_id);
      addProductItemToProductBlock(product_select, product_id);
      var block_item = block_or_block(productSaleBlock.find(".changeSelectContent[name='sales[][item_id]']"), productSaleBlock.find(".changeSelectContent[name='buy[][item_id]']"))
      selectedLi(block_item.closest(".mad-select"), item.data("value"));
      findItem = $(".allItemsSale .parentItemSale.barcode" + id);
      findItem.addClass("createFromBarcodeScan");
      findItem.find("td.barcode span").text(id);
      changeSelectProductItem(findItem.find(".changeSelectProductItem"));
      sumItemSale(findItem);
    }
  });
}

var addItemWhenBarcodeScan = function(barcode){
  var findItem = $(".allItemsSale .parentItemSale.barcode" + barcode);
  if (!findItem.length){
    autoAddItem('barcode', barcode)

  }else{
    var input_count = block_or_block(findItem.find("input[name='sales[][count]']"), findItem.find("input[name='buy[][count]']"));
    input_count.val( parseInt(input_count.val()) + 1 );
    sumItemSale(findItem);
  }
}

var addBlankBlockItem = function(bc){

  var refer = $($(".referenceItemSale").html());

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
      var parent_item = $(curr_block).closest('.parentItemSale');
      if (parent_item.length){
        var price = $(curr_block).closest(".mad-select").find(".selected").data('price');
        var input_price =  parent_item.find("input[name='buy[][price_id]']");
        if (input_price.length) input_price.val(price);
      }
    } else {
      $(curr_block).closest('.parentItemSale').find('.formLoadContentTaste').html('');
      $(curr_block).closest('.parentItemSale').find('.formLoadContentPrice').html('');
    }
    var priceSelect = block_or_block($(curr_block).closest(".parentItemSale").find(".formLoadContentPrice .mad-select").removeClass("noInit"), 
      $(curr_block).closest(".parentItemSale").find(".formLoadContentPrice input.selectProductPrice"));
    var productItemSelect = $(curr_block).closest(".parentItemSale").find(".formLoadContentTaste .mad-select").removeClass("noInit");
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
  $(".endSumPosition:visible").each(function(n, block){ result+= parseInt($(block).text())});
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
  if ($(".received_cash").length && $(".received_cash").val().length && !$(".received_cash").prop('disabled')){
    $(".received_cash").prop('disabled', true);
    $(".received_cash + .clearInput").show();
    $(".titleDelivery").val("Cдача " + ($(".received_cash").val() - result) + " руб.");
  }
}

var sumItemSale = function(block){
  var curr_block = block_or_block(block.find(".selectProductPrice .mad-select-drop .selected"), 
    block.find(".selectProductPrice"));
  var curr_price = parseInt(block_or_block( curr_block.text(), curr_block.val() ) );
  var curr_count = parseInt(block_or_block(block.find("[name='sales[][count]']"), 
    block.find("[name='buy[][count]']")).val());
  block.find(".endSumPosition").text(curr_price*curr_count);
  priceItemSale();
}


var changeSelectPriceAndCount = function(){
  $(document).on('change', '.selectPrice, .countItems', function () {
    var block = $(this).closest(".parentItemSale");
    sumItemSale(block);
  });
}
var $currentContactPriceList;
var search_contact = function(barcode_contact, id){
  $.ajax({
    type   : 'POST',
    url    : '/admin/sales/search_contact',
    data   : {barcode: barcode_contact, id: id},
    success: function (data) {
      var card_block = $(".discountCashBack");
      if (data != null){
        var purse = data.purse;
        card_block.find(".search_discount_card").val("На карте: " + purse + " руб.");
        card_block.find(".search_discount_card").attr("readonly", true);
        card_block.find("[name='contact_id']").val(data.id);
        card_block.find("[name='cashback_bank']").val(purse);
        $(".saveOrderRequest").css('display', 'inline-block');
        if (purse >= 5){
          card_block.find(".mad-select").show();
        }else{
          card_block.find(".mad-select").hide().find("[value='stash']").attr('selected', 'true');
        }
        $currentContactPriceList = data.contact_prices
        setContactPriceToProductPrice();
        card_block.find(".deleteContactBtn").show();
        card_block.find(".contactAdd").hide();

      }else{
        $(".saveOrderRequest").css('display', 'none');
        card_block.find(".deleteContactBtn").hide();
        card_block.find(".contactAdd").show();
        card_block.find(".search_discount_card").attr("readonly", false);
        card_block.find(".search_discount_card").val('');
        card_block.find("[name='cashback_bank']").val(0);
        card_block.find("[name='contact_id']").val("");
        card_block.find(".mad-select").hide().find("[value='stash']").attr('selected', 'true');
      }
    },
    error  : function () {
    }
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
  var block_product_select = block_select.closest(".parentItemSale").find(".saleProductIdSelect");
  if(block_product_select.attr("data-price") == "change") {
    block_product_select.attr("data-price", "not_change");
  }
  setContactPriceToProductPrice();
}

$(document).ready(function(){
  if($("form[action='/admin/sales']").length){
    scanBarCode(function(barcode){
      if ($(".search_discount_card").is(':focus')){
        search_contact(barcode);
      }else{
        addItemWhenBarcodeScan(barcode);
      }
    });

    $(document).keypress(function( event ) { 
      if((event.which == 104 || event.which == 1088) && $(".allOtherPopup .conteinerPopup:hidden").length){
        event.preventDefault();
        openAllOtherPopup("Поиск позиции", function(){
          var content_popup = $(".allOtherPopup .conteinerPopup");
          content_popup.html("<div class='form-group material-form-group'>" +
            "<input class='form-control search_product_item' type='text'>"+
            "<label>Название или barcode</label><ul class='searchProductItem block-material'></ul></div>");
          content_popup.find(".search_product_item").focus();
          content_popup.find(".search_product_item").val('');
        });
      }
    })

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
          }, false)
        }, 300);
      }else{
        search_contact("");
        $(".allItemsSale .saleProductIdSelect[data-price='change']").attr('data-price', 'not_change');
      }
    });

    $(document).on('keyup', '.search_product_item', function(){
      clearTimeout(timout_search_keyup);
      var input = $(this);
      if(input.val().length > 0){
        timout_search_keyup = setTimeout(function(){
          ajaxApi("get", "/api/product_items/search", {search: input.val(), type: "present"}, function(result){
            var list_search = input.closest(".conteinerPopup").find(".searchProductItem");
            list_search.find("li").remove();
            if (result.length > 0){
              list_search.show();
              $.each(result, function(n, r){
                list_search.append($("<li data-id=" + r.id + " data-barcode=" + r.barcode + ">" + r.product_title + " - " +r.title + "</li>"));
              });
              list_search.find("li").on('click', function(){
                var barcode = $(this).data("barcode")
                if (barcode != null){
                  addItemWhenBarcodeScan(barcode);
                }else{
                  autoAddItem('product_item_id', $(this).data("id"));
                }
                
                
                list_search.hide();
                $("#overlay").click();
              })
            }else{
              list_search.hide();
            }
          }, false)
        }, 300);
      }
    });


    $(document).on('click', '.priceItemSale', priceItemSale);

    $(window).keydown(function(event){
      if(event.keyCode == 13) {
        event.preventDefault();
        return false;
      }
    });
  }

  $(".orderRequestToSaleBlock .saleProductIdSelect").closest(".mad-select").removeClass("noInit").each(function(n, block){
    include_mad_select($(block), function(input){
      var bl_val = parseInt(input.val());
      addProductItemToProductBlock(input, bl_val);
    });
  });

  if( $(".orderRequestToSaleContact").length ){ 
    search_contact(null, $(".orderRequestToSaleContact").data("id"));
    priceItemSale();
  }

  $(document).on('click', '.saveOrderRequest', function(){
    $.ajax({
      type   : 'POST',
      url    : '/admin/sales/save_order_request',
      data   : $("form.formCreate").serialize(),
      success: function (data) {
        history.pushState({}, null, "/admin/sales/new?type_sale=opt&order_request=" + data.id);
        $(".idOrderRequest").val(data.id);
        $("input[name='order_request']").val(data.id);
        show_error("Заявка сохранена", 3000);
      },
      error  : function () {
        show_error("Ошибка", 3000);
      }
    });
  });

  $(document).on('click', '.deleteContactBtn', function(){
    search_contact("");
  });
  $(document).on("click", ".received_cash + .clearInput", function(){ 
    $(".received_cash").val(''); 
    $(".received_cash").prop('disabled', false);
    $(".received_cash + .clearInput").hide();
  });

  $(document).on('click', '.contactAdd.plusBtn', function(){
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
  })
});


