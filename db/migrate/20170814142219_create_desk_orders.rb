class CreateDeskOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :desk_orders do |t|
      t.integer :number
      t.decimal :total
      t.string :status

      t.timestamps
    end
  end
end
