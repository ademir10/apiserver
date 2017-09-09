class AddFormPaymentToDeskOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :desk_orders, :form_payment, foreign_key: true
  end
end
