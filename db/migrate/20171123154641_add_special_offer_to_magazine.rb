class AddSpecialOfferToMagazine < ActiveRecord::Migration
  def change
    add_column :magazines, :special_offer, :text
  end
end
