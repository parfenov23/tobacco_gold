class AddSpecialOfferToMagazine < ActiveRecord::Migration[5.2]
  def change
    add_column :magazines, :special_offer, :text
  end
end
