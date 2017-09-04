class AddBarcodeToProductItem < ActiveRecord::Migration
  def change
    add_column :product_items, :barcode, :string
  end
end
