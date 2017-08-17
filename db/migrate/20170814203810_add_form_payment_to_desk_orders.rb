class AddFormPaymentToDeskOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :desk_orders, :form_payment, :string
  end
end
