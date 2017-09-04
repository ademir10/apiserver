class AddCheckStockToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :check_stock, :boolean
  end
end
