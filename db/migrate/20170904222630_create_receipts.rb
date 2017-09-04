class CreateReceipts < ActiveRecord::Migration[5.1]
  def change
    create_table :receipts do |t|
      t.string :doc_number
      t.string :description
      t.date :due_date
      t.date :receipt_date
      t.integer :installments
      t.decimal :value_doc
      t.string :form_receipt
      t.integer :desk_order_id
      t.string :status

      t.timestamps
    end
  end
end
