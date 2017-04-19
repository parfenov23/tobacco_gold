module ApplicationHelper
  def check_if_true(item)
    if(item == 'true' or item == true or item == 1 or item == '1')
      return true
    else
      return false
    end
  end

  def default_ava_link
    '/uploads/ava.jpg'
  end

  def default_img_product(model)
    model.image_url || model.product.default_img
  end

  def user_ava(avatar)
    if avatar.to_s != ""
      "data:image/png;base64," + avatar
    else
      default_ava_link
    end
  end

  def current_user_admin?
    current_user.admin || current_user.is_admin? || current_user.is_manager? rescue false
  end

  def all_pages
    [
      ["Как это работает", "how_it_works"],
      ["Контакты", "contacts"],
      ["Бонусы", "bonuses"],
      ["Пополнить счет", "buy_rate"]
    ]
  end

  def left_bar_links
    [
      # {type: 'buy_rate', title: 'Пополнить счет', href: '/buy_rate'},
      {type: 'how_it_works', title: 'Доставка и оплата', href: '/how_it_works'},
      # {type: 'winners', title: 'Рейтинг', href: '/winners'},
      {type: 'bonuses', title: 'Скидки и Акции', href: '/bonus'},
      # {type: 'faq', title: 'F.A.Q', href: '/help'},
      {type: 'participant', title: 'Мини версия', href: '/stock'},
      {type: 'contacts', title: 'Контакты', href: '/contacts'}
    ]
  end

  def rus_case(count, n1, n2, n3)
    "#{count} #{Russian.p(count, n1, n2, n3)}"
  end

  def all_nav_li_admin
    all_navs =       [
      {url: "/admin/admin", title: "Главная"},
        {url: "/admin/products", title: "Товары"},
        {url: "/admin/stock", title: "Склад"},
        {url: "/admin/sales", title: "Продажа"},
        {url: "/admin/revision", title: "Ревизия"},
        {url: "/admin/hookah_cash", title: "Кальяны"},
        {url: "/admin/buy", title: "Закуп"},
        {url: "/admin/other_buy", title: "Прочие расходы"},
        {url: "/admin/cashbox", title: "Касса"},
        {url: '/admin/categories', title: 'Все категории'}, 
        {url: '/admin/order_requests', title: 'Заявки'}, 
        {url: '/admin/content_pages', title: 'Контент'}, 
        {url: '/admin/users', title: 'Пользователи'}, 
        {url: '/admin/contacts', title: 'Клиенты'},
        {url: '/admin/admin/manager_payments', title: 'Выплаты'}
      ]

    if current_user.is_admin?
      all_navs
    elsif current_user.is_manager?
      aviable_page = ["admin","products", "sales", "stock", "order_requests", "contacts"]
      all_navs.map{|nav| nav if aviable_page.include?(nav[:url].gsub("/admin/", ""))}.compact
    end
    
  end
end
