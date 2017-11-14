class AddTipoVendaToDeskOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :desk_orders, :tipo_venda, :string
  end
end
