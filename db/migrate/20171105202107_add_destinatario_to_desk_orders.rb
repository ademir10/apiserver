class AddDestinatarioToDeskOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :desk_orders, :destinatario, foreign_key: true
  end
end
