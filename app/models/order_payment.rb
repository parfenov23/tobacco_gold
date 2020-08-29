class OrderPayment < ActiveRecord::Base
  belongs_to :company
  default_scope { order(created_at: :desc) }
  
  def self.all_tariff
    [{
      key: "basic",
      title: "Базовый",
      amount: 400,
      opportunities: ["1 магазин", "1 сотрудник"]
    },{
      key: "simple",
      title: "Простой",
      sub_title: "Все функции для одного магазина",
      amount: 1000,
      pay_year: 750,
      opportunities: ["1 магазин", "Сотрудники без ограничений", "Готовый веб сайт", "Чат поддержки"]
    },{
      key: "standart",
      title: "Стандарт",
      sub_title: "Все функции для растущего бизнеса",
      amount: 1500,
      pay_year: 1200,
      opportunities: ["Интеграция с Онлайн-кассой", "1 магазин", "Сотрудники без ограничений", 
        "Готовый веб сайт", "Помощь в продвижении сайта", "Чат поддержки", "Все отчеты", "Email отчеты"]
    },{
      key: "unlimited",
      title: "Безлимит",
      sub_title: "Все функции CRMStock без ограничений",
      amount: 2500,
      pay_year: 2100,
      opportunities: ["Интеграция с Онлайн-кассой", "1 магазин", "Сотрудники без ограничений", 
        "Готовый веб сайт", "Помощь в продвижении сайта", "Редактирование шаблона сайта", "API для интеграций", 
        "Все отчеты", "Email отчеты", "Обучение работы в системе", "Чат поддержки 24/7", "Поддержка по телефону 24/7"]
    }]
  end

  def self.find_tariff(key)
    all_tariff.select {|r| r[:key] == key }.first
  end
end
