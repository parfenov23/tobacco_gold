var allot_item = function(barcode){
  var curr_block = $(".list-group-item[data-barcode='" +  barcode +"']");
  if (curr_block.length){
    var input_block = curr_block.find("input.revisionCount")
    input_block.val( (parseInt(input_block.val()) || 0) + 1 );
    $(".allotItemRevision").removeClass("allotItemRevision");
    curr_block.addClass("allotItemRevision");
  }else{
    show_error("Не найдено", 3000);
  }


}

var from_revision = function(){
  var btn = $(this);
  openAllOtherPopup("Ревизия - " + btn.closest("form").find(".panel_gray_common").text(), function(){
    var content_popup = $(".allOtherPopup .conteinerPopup");
    content_popup.html('');
    content_popup.append($("<form class='revision' action='/admin/revision' method='post'><input name='product_item' type='hidden' value='" + btn.data('id') + "'></form>"));
    var all_items = btn.closest("form").find(".list-group-item");
    all_items.each(function(n, block){
      var curr_count = $(block).find("input").val();
      var should_count = $(block).find(".js_pasteCountItem").data('count');
      if (curr_count != should_count){
        var curr_input = $(block).find("input");
        content_popup.find("form").append("<div class='blockItem parentListItem'>"+
          "<span>" + $(block).find("span").text() + "</span>" +
          "<input class='revisionCount' name=" + curr_input.attr("name") + " value=" + curr_count + ">" +
          "<div class='btn btn-success-material pull-right js_pasteCountItem' data-count='"+ should_count +"'>" + should_count + "</div>");
      }
    });
    content_popup.find("form").append("<button class='btn btn-primary-material submit' formnovalidate='' type='submit'>Сохранить</button>")
    content_popup.find(".js_pasteCountItem").on('click', pasteCountItem);
  });
}

var pasteCountItem = function(){
  $(this).closest(".parentListItem").find(".revisionCount").val($(this).data('count'));
}

$(document).ready(function(){ 
  if ($(".allProductsRevision").length){
    scanBarCode(function(barcode){
      allot_item(barcode);
    });
  }

  $(document).on('click', '.js_pasteCountItem', pasteCountItem)
  $(document).on('click', '.jsFormRevision', from_revision);

});