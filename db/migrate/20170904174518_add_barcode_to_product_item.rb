class AddBarcodeToProductItem < ActiveRecord::Migration[5.2]
  def change
    add_column :product_items, :barcode, :string
  end
end
