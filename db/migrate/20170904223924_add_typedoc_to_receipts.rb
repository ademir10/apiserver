class AddTypedocToReceipts < ActiveRecord::Migration[5.1]
  def change
    add_column :receipts, :type_doc, :string
  end
end
