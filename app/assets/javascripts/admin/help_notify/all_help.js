function all_helps() { //весь массив помощи
    var arr_help = [
        {
            block         : "",
            color         : "#6A199A",
            btn_text      : "ПРОЙТИ ОБУЧЕНИЕ ЗА 30 СЕКУНД",
            btn_close_text: "ПРОПУСТИТЬ ОБУЧЕНИЕ",
            btn_next_css  : {width: 260},
            btn_color     : "#9B65BB",
            title         : "Добро пожаловать в Онлайн систему по ведению складского учета OnlineStock",
            content       : "Буквально несколько слов о том как тут все устроено, хорошо?"
        },
        {
            block     : ".user_info .js_openUserPopupInfo img",
            btn_text  : "ДАЛЕЕ",
            color     : "#1565C0",
            btn_color : "#54D2E2",
            //btn_action: "open_right_bar_tags",
            skip_btn  : true,
            text_align: "left",
            content   : "Это ваш профиль! Отсуда вы можете быстро попасть в заявки с сайта и произвести основные настройки."
        },
        {
            block     : ".left-bar .menu-li .products",
            btn_text  : "ДАЛЕЕ",
            color     : "#6A1B9A",
            btn_color : "#54D2E2",
            skip_btn  : true,
            text_align: "left",
            btn_action  : "go_to_products",
            content   : "В этом разделе находятся все Ваши товары."
        },
        {
            block     : ".fab",
            btn_text  : "ДАЛЕЕ",
            color     : "#00838F",
            btn_color : "#54D2E2",
            skip_btn  : true,
            text_align: "left",
            position  : "center",
            content   : "Эта кнопка создания нового товара! Она всегда тут, не теряй ее."
        },
        {
            block     : ".left-bar .menu-li .cashbox",
            btn_text  : "ДАЛЕЕ",
            color     : "#0277BD",
            btn_color : "#54D2E2",
            skip_btn  : true,
            text_align: "left",
            btn_action  : "go_to_cashbox",
            content   : "Это раздел КАССА, здесь вы всегда сможете увидить все ваши доходы и расходы. Давай посмотрим что внутри :)"
        },

        {
            block       : ".leftContentBar .general",
            btn_text    : "ДАЛЕЕ",
            //btn_close_text: "НАЧАТЬ РАБОТУ",
            // btn_next_css: {width: 190},
            skip_btn    : true,
            color       : "#4527A0",
            btn_color   : "#54D2E2",
            text_align  : "left",
            content     : "Здесь вы можете видеть: общую кассу, сколько денег сейчас в товаре и умный прогноз ваших продаж в этом месяце"
        },
        {
            block     : ".leftContentBar .debts",
            btn_text  : "ДАЛЕЕ",
            color     : "#00838F",
            btn_color : "#54D2E2",
            // skip_btn  : true,
            text_align: "left",
            position  : "center",
            content   : "А здесь будет список поставщиков которым вы должны оплатить поставки. Перейдем к продажам?"
        },
        {
            block     : ".left-bar .menu-li .sales",
            btn_text  : "ДАЛЕЕ",
            color     : "#0277BD",
            btn_color : "#54D2E2",
            skip_btn  : true,
            text_align: "left",
            btn_action  : "go_to_sales",
            content   : "Это раздел ПРОДАЖИ. Здесь вы будите видеть список ваших продаж и отсюда же можете создавать новые продажи. Посмотрим что там внутри? :)"
        },
        {
            block     : "button.btn",
            btn_text  : "НАЧАТЬ ПОЛЬЗОВАТЬСЯ СИСТЕМОЙ",
             btn_next_css: {width: 340},
            color     : "#0277BD",
            btn_color : "#54D2E2",
            skip_btn  : true,
            text_align: "left",
            btn_action  : "go_to_index",
            content   : "Нажимая на копку ДОБАВИТЬ ПРОДАЖУ, Вы сможете создать новую продажу! На этом у нас пока что все, если что мы всегда на связи! Хороших продаж :)"
        },

    ];
    return arr_help;
}

function pause(n) {
  var today = new Date();
  var today2 = today;
  while ((today2 - today) <= n){
    today2 = new Date()
  }
}

function actions_help(type) { // действия при нажатие на кнопку далее
  if (type == "go_to_products"){
    $('body').hide();
    window.location.href = "/admin/products"
  }
  if (type == "go_to_index"){
    $('body').hide();
    window.location.href = "/admin/admin"
  }
  if (type == "go_to_cashbox"){
    $('body').hide();
    window.location.href = "/admin/cashbox"
  }
  if (type == "go_to_sales"){
    $('body').hide();
    window.location.href = "/admin/sales"
  }
}