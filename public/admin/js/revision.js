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
  $(".allotItemRevision").removeClass("allotItemRevision");
  $(".list-group-item[data-barcode='" +  barcode +"']").addClass("allotItemRevision");
}

$(document).ready(function(){ 
  scanBarCode();

  $(window).keydown(function(event){
    if(event.keyCode == 13) {
      event.preventDefault();
      return false;
    }
  });
});