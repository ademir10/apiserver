class AddTypeServiceToDeskOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :desk_orders, :type_service, :string
  end
end
