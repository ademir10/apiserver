class AddObsAndTrocoToDeskOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :desk_orders, :troco_para, :decimal
    add_column :desk_orders, :obs, :text
  end
end
