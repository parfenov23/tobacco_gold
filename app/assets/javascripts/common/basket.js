var addCountToBasket = function(){
  var btn_id = $(this).data('id');

  $.ajax({
    type   : 'POST',
    url    : '/add_item_to_basket',
    data   : {item_id: btn_id},
    success: function (data) {
      show_error('Товар добавлен в корзину', 3000);
      $("header .my_rate .count").text(data.length);
    },
    error  : function () {
      show_error('Ошибка', 3000);
    }
  });
}

var rmItemInBasket = function(){
  var btn = $(this);
  var btn_id = $(this).data('id');
  $.ajax({
    type   : 'POST',
    url    : '/rm_item_to_basket',
    data   : {item_id: btn_id},
    success: function (data) {
      show_error('Товар удален из корзины', 3000);
      $("header .my_rate .count").text(data.length);
      btn.closest(".item_content").remove();
    },
    error  : function () {
      show_error('Ошибка', 3000);
    }
  });
}


$(document).ready(function () {
  $(".js__addToBasket").on('click', addCountToBasket);

  $(".js__rmItemInBasket").on('click', rmItemInBasket);
});