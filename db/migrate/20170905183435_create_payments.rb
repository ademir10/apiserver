class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.string :doc_number
      t.string :type_doc
      t.references :supplier, foreign_key: true
      t.string :description
      t.date :due_date
      t.date :payment_date
      t.integer :installments
      t.decimal :value_doc
      t.string :form_payment
      t.string :status

      t.timestamps
    end
  end
end
