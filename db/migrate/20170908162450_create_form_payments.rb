class CreateFormPayments < ActiveRecord::Migration[5.1]
  def change
    create_table :form_payments do |t|
      t.string :type_payment

      t.timestamps
    end
  end
end
