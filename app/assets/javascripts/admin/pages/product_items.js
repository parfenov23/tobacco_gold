var submitNewModel = function(btn){
  var form = btn.closest("form");
  var data = form.serializeArray();
  data.push({name: 'typeAction', value: "json"})

  $.ajax({
    type   : 'POST',
    url    : form.attr("action"),
    data   : data,
    success: function (data) {
      location.reload();
    },
    error  : function () {
      show_error('Ошибка', 3000);
    }
  });
}

var add_new_tag = function (tag_id, title_tag){
  var product_item_id = $(".conteinerPopup form .current_id").val();
  if (tag_id != null){
    var type = "add";
  }
  if (title_tag != null){
    var type = "new";
  }
  ajaxApi("post", "/admin/tags", {title: title_tag, product_item_id: product_item_id, tag_id:tag_id, type: type}, function(result){
    var new_tag = $( "<div class='tag'>" +
      "<span class='title_tag'>" + result.title + "</span>" +
      "<span class='remove_tag' data-id='"+ result.id +"'>✖</span>" +
      "</div>");
    $(".add_new_tag").val("");
    $(".all__tags").append(new_tag);
    // $(".remove_tag[data-id='"+ result.id +"']").on('click', remove_tag);
  });

}

var remove_tag = function(){
  var product_item_id = $(".conteinerPopup form .current_id").val();
  var btn_remove = $(this);
  ajaxApi("post", "/admin/tags/remove_product_item", {id: $(this).data('id'), product_item_id: product_item_id}, function(result){
    btn_remove.closest(".tag").remove();
  });
}


$(document).ready(function(){
  var timout_search_keyup = ""
  $(document).on('keyup', '.add_new_tag', function(){
    clearTimeout(timout_search_keyup);
    var input = $(this);
    var list_search = input.closest(".block__tags").find(".find_tags");
    if(input.val().length > 0){
      timout_search_keyup = setTimeout(function(){
        ajaxApi("get", "/admin/tags/search", {search: input.val()}, function(result){
          // Body Function ==========
          list_search.find("li").remove();
          if (result.length > 0){
            list_search.show();
            $.each(result, function(n, r){
              list_search.append($("<li data-id="+ r.id +">" + r.title + "</li>"));
            });
            list_search.find("li").on('click', function(){
              add_new_tag($(this).data('id'), null);
              list_search.hide();
            })
          }else{
            list_search.hide();
          }
          // ===================
        }, false)
      }, 300);
    }else{
      list_search.hide();
    }
  });
  $(document).on('keyup', '.add_new_tag',function(e) {
    if(e.which == 13) {
      add_new_tag(null, $(this).val());
    }
  });

  $(document).on('click', '.all__tags .tag .remove_tag', remove_tag);

})