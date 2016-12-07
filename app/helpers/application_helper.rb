module ApplicationHelper
  # def current_user
  #   session[:user_pass] == 'parfenov407'
  # end

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

  def user_ava(avatar)
    if avatar.to_s != ""
      "data:image/png;base64," + avatar
    else
      default_ava_link
    end
  end

  def current_user_admin?
    current_user.admin rescue false
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
      {type: 'how_it_works', title: 'Как мы работаем?', href: '/how_it_works'},
      # {type: 'winners', title: 'Рейтинг', href: '/winners'},
      {type: 'bonuses', title: 'Скидки и Акции', href: '/bonus'},
      {type: 'faq', title: 'F.A.Q', href: '/help'},
      {type: 'contacts', title: 'Контакты', href: '/contacts'},
      {type: 'participant', title: 'Мини версия', href: '/stock'}
    ]
  end

  def rus_case(count, n1, n2, n3)
    "#{count} #{Russian.p(count, n1, n2, n3)}"
  end
end
