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
                  allot_item(barcode);
                }
                chars = [];
                pressed = false;
              },500);
    }
    pressed = true;
  });
}

var allot_item = function(barcode){
  var curr_block = $(".list-group-item[data-barcode='" +  barcode +"']");
  var input_block = curr_block.find("input.revisionCount")
  input_block.val( (parseInt(input_block.val()) || 0) + 1 );
  $(".allotItemRevision").removeClass("allotItemRevision");
  curr_block.addClass("allotItemRevision");

}

var pasteCountItem = function(){
  $(this).closest(".list-group-item").find(".revisionCount").val($(this).data('count'));
}

$(document).ready(function(){ 
  scanBarCode();
  $(document).on('click', '.js_pasteCountItem', pasteCountItem)

  $(window).keydown(function(event){
    if(event.keyCode == 13) {
      event.preventDefault();
      return false;
    }
  });
});