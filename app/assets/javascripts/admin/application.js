//= require_tree ./pages
//= require_tree ./help_notify
//= require vendor/serialize_file
//= require vendor/jquery.session
//= require vendor/jquery_round
// Pusher.logToConsole = true;
var pusher = new Pusher('1a55ade886312565bd6d', {
  cluster: 'eu',
  encrypted: true
});

var block_or_block = function(b1, b2){
  if(b1.length){
    return b1
  }else{
    return b2
  }
}


show_error = function (text, duration) {
  var el = $('#alert');
  el.find('.text').text(text);
  el.show(300);
  el.find('.close').click(function () {
    el.hide(400);
  });
  if (duration){
    setTimeout(function () {
      el.hide(400);
    }, duration);
  }
};

var getTitleAndHrefBtnInOtherPopup = function(btn){
  var title = $(btn).data('title');
  var url = $(btn).attr("href");
  loadContentInOtherPopup(title, url);
}

var submitUpdateModel = function(btn){
  var form = btn.closest("form");
  var data = form.serializeFile();
  data.push({name: 'typeAction', value: "json"})

  $.ajax({
    type   : 'PUT',
    url    : form.attr("action"),
    data   : data,
    success: function (data) {
      show_error('Сохранено', 3000);
    },
    error  : function () {
      show_error('Ошибка', 3000);
    }
  });
}

var loadContentInOtherPopup = function(title, url){
  openAllOtherPopup(title, function(){
    $.ajax({
      type   : 'get',
      url    : url,
      data   : {typeAction: "json"},
      success: function (data) {
        var pasteContent = $(".allOtherPopup .conteinerPopup").html($(data));
        pasteContent.find(".defaultInitMdSelect").each(function(i, block){
          include_mad_select($(block));
        });
        pasteContent.find("button[type='submit']").on('click', function(event){
          event.preventDefault();
          submitUpdateModel($(event.target));
        });
        pasteContent.find("input[accept='image/*,image/jpeg']").on('change', function(){
          $(this).closest(".custom-file").find("label").text(this.files[0].name)
        })
      },
      error  : function () {
        show_error('Ошибка', 3000);
      }
    });
  });
}

var submitUpdateModel = function(btn){
  var form = $(btn).closest("form");
  var url = form.attr("action");
  var data = form.serializefiles();
  data.append('typeAction', "json");
  $.ajax({
    url: url,
    type: form.find("input[name='_method']").val(),
    dataType: "JSON",
    data: data,
    processData: false,
    contentType: false,
    success: function (data, status)
    {
      show_error("Сохранено", 3000);
      closeAllOtherPopup();
      if(data.jq != null){
        eval(data.jq);
      }
      if(data.url != undefined){
        window.location.href = data.url
      }
    },
    error: function (xhr, desc, err)
    {
      show_error("Ошибка", 3000);
    }
  });
}

var current_user_api_key = function(){
  return $("#currentUserApiKey").val();
}

var current_user_api_url = function(){
  return $("#currentUserUrl").val();
}
var current_user_magazine_id = function(){
  return $("#currentMagazineId").val();
}

var ajaxApi = function(type, method, data, end_action, view_error){
  if (data == undefined) data = {};
  if (view_error == undefined) view_error = true;
  var auth = {api_key: current_user_api_key};
  var params = $.extend(auth, data); 

  $.ajax({
    type   : type,
    url    : (current_user_api_url() + method),
    data   : params,
    success: function (data) {
      if (end_action != undefined) end_action(data);
      if (view_error) show_error('Успешно', 3000);
      
    },
    error  : function () {
      show_error('Ошибка', 3000);
    }
  });
}

var btnAjaxRemove = function(btn_this){
  var btn = $(btn_this);
  ajaxApi('get', btn.attr("href"), {}, function(){
    btn.closest(".removeParentBlock").remove();
  });
}

var scanBarCode = function(end_function){
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
                if (chars.length >= 7) {
                  end_function(chars.join(""))
                }
                chars = [];
                pressed = false;
              },500);
    }
    pressed = true;
  });
}

var selectedLi = function(block, val){
  var ul = block.find("ul");
  ul.find(".selected").removeClass("selected");
  var curr_li = ul.find("li[data-value='" + val + "']");
  curr_li.addClass("selected");
  ul.closest(".parentSelectMd").find(".titleSelect").text(curr_li.text());
  ul.closest(".parentSelectMd").find("input").val(val);
}

var include_mad_select = function(block, end_funct){
  if (!$(block).hasClass("noInit")){
    var $input = $(block).find("input"),
    $ul = $(block).find(".listSelectMd > ul"),
    $ulDrop =  $ul;
    $(block)
    .on({
      hover : function() { madSelectHover ^= 1; },
      click : function(e) { 
        $ulDrop.addClass("show");
        // $(block).addClass("includeMad");
        var size_block = 290;
        if ($ulDrop.find("li").length <= 2){ size_block = 160 }
          var top_block = $(window).innerHeight() - ($ulDrop.closest(".parentSelectMd").position().top + size_block) - 80;
        if (top_block < 0) { $ulDrop.closest(".listSelectMd").css({top: top_block}) }
      }
  });
    // PRESELECT
    // $ul.add($ulDrop).find("li[data-value='"+ $input.val() +"']").addClass("selected");
    if ($input.val() != undefined && $input.val().length){
      $ulDrop.find("li[data-value='"+ $input.val() +"']").addClass("selected");
      var title = $ulDrop.find("li[data-value='"+ $input.val() +"']").text();
      $(block).find(".titleSelect").text(title);
    }else{
      var title = $ulDrop.find("li:first").text();
      $(block).find(".titleSelect").text(title);
    }
    
    // MAKE SELECTED
    $ulDrop.on("click", "li", function(evt) {
      evt.stopPropagation();
      $input.val($(this).data("value")); // Update hidden input value
      $(block).find(".titleSelect").text($(this).text());
      $(this).add(this).addClass("selected")
      .siblings("li").removeClass("selected");
      $ul.removeClass("show");
      if (end_funct != undefined) end_funct($input);
    });
    // UPDATE LIST SCROLL POSITION
    $ul.on("click", function() {
      var liTop = $ulDrop.find("li.selected").position().top;
      $ulDrop.scrollTop(liTop + $ulDrop[0].scrollTop);
    });
  }
}

var isMobile = {
    Android   : function () {
        return navigator.userAgent.match(/Android/i);
    },
    BlackBerry: function () {
        return navigator.userAgent.match(/BlackBerry/i);
    },
    iOS       : function () {
        return navigator.userAgent.match(/iPhone|iPad|iPod/i);
    },
    Opera     : function () {
        return navigator.userAgent.match(/Opera Mini/i);
    },
    Windows   : function () {
        return navigator.userAgent.match(/IEMobile/i);
    },
    any       : function () {
        return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
    }
};

$(document).ready(function(){
  $(".parentSelectMd").not(".noInit").each(function() {
    include_mad_select(this);
  });
  include_mad_select($(".userHeader .parentSelectMd").removeClass("noInit"), function(input){
    window.location.assign(window.location.pathname + "?type=" + input.val());
  });

  $(".searchParamSelect .parentSelectMd").each(function(n, e){
    var parent_block = $(e).closest(".searchParamSelect");
    var param_search = parent_block.data("param");
    include_mad_select($(e).removeClass("noInit"), function(input){
      window.location.assign(window.location.pathname + "?" + param_search + "=" + input.val());
    });
  })

  $(document).on('click', '.js_loadContentInOtherPopup', function(event){
    event.preventDefault();
    getTitleAndHrefBtnInOtherPopup($(this));
  });
  $(document).on('click', '.js_submitNewModel', function(event){
    event.preventDefault();
    submitNewModel($(event.target));
  });
  $(document).on('click', '.js__remove', function(event) {
    event.preventDefault();
    btnAjaxRemove(this);
  });

  $(document).on('click', '.js_openUserPopupInfo', function(){
    if ($(".popupUserAvaInfo:visible").length){
      $(".popupUserAvaInfo").hide();
    }else{
      $(".popupUserAvaInfo").show();
    }
    
  });

  $()
  
  $(window).keydown(function(event){
    if(event.keyCode == 13) {
      if (!$(event.target).is( "textarea" )){
        event.preventDefault();
        return false;
      }
    }
  });

  $(".inputSearchContent").keydown(function(event){ if(event.keyCode == 13) {
    window.location.href = "?search=" + $(event.target).val();
  } })

  $(document).on('click', 'body', function(e){
    var block = $(e.target);
    if(!block.closest(".user_info").length){
      $(".popupUserAvaInfo").hide();
    }
    if(!block.closest(".parentSelectMd").length){
      $(".parentSelectMd ul.show").removeClass("show");
    }
  });
});

