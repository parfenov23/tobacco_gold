module ApplicationHelper
  def check_if_true(item)
    if(item == 'true' or item == true or item == 1 or item == '1')
      return true
    else
      return false
    end
  end

  # Заголовок страницы
  def layout_title
    "#{curr_title_admin_header} | Hookah Stock"
  end

  def title(page_title=nil)
    @page_title = page_title
  end

  def page_title(default_title = '')
    @page_title || default_title
  end

  def default_ava_link
    '/uploads/ava.jpg'
  end

  def default_img_product(model)
    model.image_url.present? ? model.image_url : model.product.default_img
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

  def current_magazine
    current_user.magazine
  end

  def current_company
    current_magazine.company
  end

  def rus_case(count, n1, n2, n3)
    "#{count} #{Russian.p(count, n1, n2, n3)}"
  end

  def current_user_present_and_control
    current_user.present? ? current_user.is_admin? || current_user.is_manager? : false
  end

  def curr_title_admin_header(add_title=nil)
    curr_title = nil
    all_navs_admin.each{|nav| curr_title = nav[:title] if nav[:url] == request.env["PATH_INFO"] }
    "#{add_title}#{curr_title}"
  end

  def all_navs_admin
    [ 
      {url: "/admin/admin", title: "Главная"},
      {url: "/admin/products", title: "Товары"},
      {url: '/admin/categories', title: 'Категории', display: false}, 
      # {url: '/admin/mix_boxes', title: 'Миксы'}, 
      {url: "/admin/stock", title: "Склад"},
      {url: "/admin/sales", title: "Продажи"},
      {url: "/admin/transfers", title: "Трансферы"},
      {url: "/admin/revision", title: "Ревизия"},
      # {url: "/admin/hookah_cash", title: "Кальяны"},
      {url: "/admin/buy", title: "Закупы"},
      {url: "/admin/other_buy", title: "Прочие расходы", display: false},
      # {url: "/admin/admin/sms_phone", title: "Смс банк"},
      {url: "/admin/cashbox", title: "Касса"},
      {url: '/admin/order_requests', title: 'Заявки'}, 
      # {url: '/admin/content_pages', title: 'Контент'}, 
      {url: '/admin/users', title: 'Пользователи'}, 
      {url: '/admin/contacts', title: 'Клиенты'},
      {url: '/admin/admin/manager_payments', title: 'Выплаты', display: false},
      # {url: '/admin/admin/search', title: 'Поиск'},
      {url: '/admin/providers', title: 'Поставщики'},
      {url: '/admin/magazins', title: 'Компания'},
      {url: '/admin/product_items', title: 'Вкусы', display: false},
      {url: '/admin/product_prices', title: 'Цены', display: false},
      {url: '/admin/provider_items', title: 'Цены поставщика', display: false},
      {url: '/admin/contact_prices', title: 'Цены клиента', display: false},
      {url: '/admin/sales/new', title: 'Продажа', display: false}, 
      {url: '/admin/buy/new', title: 'Закуп', display: false},
      {url: '/admin/transfers/new', title: 'Трансфер', display: false}
    ]
  end

  def all_nav_li_admin
    all_navs = all_navs_admin 
    if current_user.is_admin?
      all_navs
    elsif current_user.is_manager?
      aviable_page = ["admin","products", "sales", "stock", "order_requests", "contacts", "admin/search"]
      all_navs.map{|nav| nav if aviable_page.include?(nav[:url].gsub("/admin/", ""))}.compact
    end
    
  end

  def current_company
    @current_company
  end
end
