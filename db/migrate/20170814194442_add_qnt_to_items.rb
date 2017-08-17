class AddQntToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :qnt, :integer
    add_column :items, :val_unit, :decimal
    add_column :items, :val_total, :decimal
  end
end
