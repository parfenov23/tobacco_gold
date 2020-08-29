var orderPayment = function(){
  show_error("Обрабатываем платеж", 5000);
  var btn = $(this);
  btn.hide();
  var tariff = btn.data("tariff");
  var count_month = btn.data("count_month");
  $.ajax({
    url: "/admin/order_payments",
    type: "POST",
    data: {tariff: tariff, count_month: count_month},
    success: function (data, status){
      window.location.href = data.redirect_url
    },
    error: function (xhr, desc, err){
      show_error("Ошибка", 3000);
    }
  });
}

$(document).ready(function(){
  $(".plan .listSelectMd ul li").on('click', function(){
    var plan_block = $(this).closest(".plan");
    var count_month = $(this).data("value");
    var amount = parseInt(plan_block.data("amount"));
    var pay_year = parseInt(plan_block.data("pay_year"));
    var current_price = count_month * amount;
    if(count_month == 12 && pay_year > 0){
      current_price = pay_year * count_month;
    }
    plan_block.find("span.current_price").text(current_price);
    plan_block.find(".js_orderPayment").data("count_month", count_month);
  });

  $(".js_orderPayment").on('click', orderPayment);
});