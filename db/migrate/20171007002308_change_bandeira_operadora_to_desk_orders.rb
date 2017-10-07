class ChangeBandeiraOperadoraToDeskOrders < ActiveRecord::Migration[5.1]
  def change
    change_column :desk_orders, :bandeira_operadora, :string
  end
end
