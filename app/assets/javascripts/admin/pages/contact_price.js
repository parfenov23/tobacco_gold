var includeEditSelect = function(){
  $("div[data-type='edit'] .form-group .mad-select").each(function(i, e){
    $(e).removeClass("noInit")
    include_mad_select($(e), function(block){
      findAndShowPrice(block);
    });
  });
}

var findAndShowPrice = function(block){
  var product_id = $(block).closest(".mad-select").find("input").val();
  var find_price = $(block).closest(".blockContactPrice").find(".form-copy-md-select .product_" + product_id);
  block.closest(".blockContactPrice").find(".currentPrice .mad-select").remove();
  if (find_price.length){
    var new_block_price = find_price.clone();
    block.closest(".blockContactPrice").find(".currentPrice").append( new_block_price );
    new_block_price.removeClass("noInit");
    include_mad_select($(new_block_price), function(block){
      $(block).closest(".blockContactPrice").find("input[name='contact_prices[product_price_id]']").val($(block).closest(".mad-select").find("input").val());
    });
  }
}

$(document).ready(function(){
  $("div[data-type='new'] .form-group .mad-select").removeClass("noInit").each(function(i, e){
    include_mad_select($(e), function(block){
      findAndShowPrice(block);
    });
  });
})