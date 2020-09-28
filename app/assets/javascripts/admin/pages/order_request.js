$(document).ready(function(){
  $('.js_change_price_order[contenteditable=true]').focus(function() {
    $(this).data("initialText", $(this).html());
  }).blur(function() {
    if ($(this).data("initialText") !== $(this).html()) {
      var new_price = parseFloat($(this).text());
      var item_id = $(this).data("item_id");
      var order_id = $(this).data("order_id");
      $.ajax({
        type: "get",
        url: '/admin/order_requests/'+order_id+"/update_new_price",
        data: {new_price: new_price, item_id: item_id},
        success: function(data){
          document.location.reload(true);
        }
      });
    }
  });

  $('.js_change_count_order[contenteditable=true]').focus(function() {
    $(this).data("initialText", $(this).html());
  }).blur(function() {
    if ($(this).data("initialText") !== $(this).html()) {
      var new_count = parseFloat($(this).text());
      var item_id = $(this).data("item_id");
      var order_id = $(this).data("order_id");
      $.ajax({
        type: "get",
        url: '/admin/order_requests/'+order_id+"/update_new_count",
        data: {new_count: new_count, item_id: item_id},
        success: function(data){
          document.location.reload(true);
        }
      });
    }
  });

  $('.js_change_info_order_reuqest[contenteditable=true]').focus(function() {
    $(this).data("initialText", $(this).html());
  }).blur(function() {
    if ($(this).data("initialText") !== $(this).html()) {
      var type_update = $(this).data("type_update");
      var val = $(this).text();
      var order_id = $(this).data("order_id");
      $.ajax({
        type: "get",
        url: '/admin/order_requests/'+order_id+"/update_info",
        data: {type_update: type_update, val: val},
        success: function(data){
          // document.location.reload(true);
        }
      });
    }
  });
});