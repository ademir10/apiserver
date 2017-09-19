class AddFormPaymentToReceipts < ActiveRecord::Migration[5.1]
  def change
    add_reference :receipts, :form_payment, foreign_key: true
  end
end
