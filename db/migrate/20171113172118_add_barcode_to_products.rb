class AddBarcodeToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :barcode, :string
  end
end
