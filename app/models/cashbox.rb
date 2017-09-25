class Cashbox < ActiveRecord::Base

  def self.first_url
    "cashbox"
  end

  def calculation(type, price, type_sum)
    curr_sum = JSON.parse(to_json)[type]
    result = type_sum ? {type.to_sym => (curr_sum + price)} : {type.to_sym => (curr_sum - price)}
    update(result)
  end
end
