class Category < ActiveRecord::Base
  has_many :items, :dependent => :destroy
  has_many :products

  def self.first_url
    "categories"
  end

  # def as_json(*)
  #   super.except("created_at", "updated_at").tap do |hash|
  #     hash["products"] = products.as_json
  #   end
  # end

end
