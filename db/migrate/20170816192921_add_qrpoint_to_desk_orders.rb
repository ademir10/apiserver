class AddQrpointToDeskOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :desk_orders, :qrpoint, foreign_key: true
  end
end
