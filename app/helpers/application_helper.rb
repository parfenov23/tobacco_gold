module ApplicationHelper
  def check_if_true(item)
    if(item == 'true' or item == true or item == 1 or item == '1')
      return true
    else
      return false
    end
  end

  # Заголовок страницы
  def layout_title(superuser=false)
    "#{superuser ? curr_title_superuser_header : curr_title_admin_header} | CRM Stock"
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

  def curr_hash_nav_li(all_navs_admin = all_navs_admin)
    curr_li = nil
    all_navs_admin.each{|nav| curr_li = nav if nav[:url] == request.env["PATH_INFO"] }
    curr_li
  end

  def curr_title_admin_header(add_title=nil, all_navs_admin = all_navs_admin)
    curr_hash_nav_li(all_navs_admin).present? ? "#{add_title}#{curr_hash_nav_li(all_navs_admin)[:title]}" : "#{add_title}"
  end

  def curr_title_superuser_header(add_title=nil)
    curr_hash_nav_li(all_navs_superuser).present? ? "#{add_title}#{curr_hash_nav_li(all_navs_superuser)[:title]}" : "#{add_title}"
  end

  def all_navs_admin
    [ 
      {url: "/admin/admin", title: "Главная", icon: "home"},
      {url: "/admin/products", title: "Товары", icon: "products"},
      {url: '/admin/categories', title: 'Категории', display: false}, 
      # {url: '/admin/mix_boxes', title: 'Миксы'}, 
      {url: "/admin/stock", title: "Склад", icon: "stock"},
      {url: "/admin/sales", title: "Продажи", icon: "sales"},
      {url: "/admin/transfers", title: "Трансферы", icon: "transfers", display: (current_company.blank? || current_company.magazines.count > 1 ? true : false)},
      {url: "/admin/revision", title: "Ревизия", icon: "revision"},
      # {url: "/admin/hookah_cash", title: "Кальяны"},
      {url: "/admin/buy", title: "Закупы", icon: "buy"},
      {url: "/admin/other_buy", title: "Прочие расходы", display: false},
      # {url: "/admin/admin/sms_phone", title: "Смс банк"},
      {url: "/admin/cashbox", title: "Касса", icon: "cashbox"},
      {url: '/admin/order_requests', title: 'Заявки', icon: "order_requests"}, 
      {url: '/admin/content_pages', title: 'Контент', icon: "page_content", display: (current_company.blank? || current_company.domain.present? ? true : false)}, 
      {url: '/admin/users', title: 'Пользователи', icon: "users"}, 
      {url: '/admin/contacts', title: 'Клиенты', icon: "contacts"},
      {url: '/admin/admin/manager_payments', title: 'Выплаты', display: false},
      {url: '/admin/providers', title: 'Поставщики', icon: "providers"},
      {url: '/admin/magazins', title: 'Компания', icon: "settings"},
      {url: '/admin/product_items', title: 'Позиции', display: false},
      {url: '/admin/product_prices', title: 'Цены', display: false},
      {url: '/admin/provider_items', title: 'Цены поставщика', display: false},
      {url: '/admin/contact_prices', title: 'Цены клиента', display: false},
      {url: '/admin/sales/new', title: 'Продажа', display: false}, 
      {url: '/admin/buy/new', title: 'Закуп', display: false},
      {url: '/admin/transfers/new', title: 'Трансфер', display: false},
      {url: '/admin/order_payments', title: 'Тарифы', display: false}
    ]
  end

  def all_navs_superuser
    [
      {url: '/superuser', title: 'Главная', icon: "home"},
      {url: '/superuser/company', title: 'Компании', icon: "settings"}
    ]
  end

  def all_nav_li_admin
    all_navs = all_navs_admin 
    if current_user.is_admin?
      all_navs
    elsif current_user.is_manager?
      aviable_page = ["admin", "sales", "stock", "order_requests", "contacts"]
      all_navs = all_navs.map{|nav| nav if aviable_page.include?(nav[:url].gsub("/admin/", ""))}.compact
    end
    if current_company.setting_nav.present?
      arr_setting = current_company.setting_nav.split(",")
      all_navs = all_navs.map{|nav| nav if arr_setting.include?(nav[:url])}.compact
    end
    all_navs 
  end

  def current_company
    @current_company
  end
end
