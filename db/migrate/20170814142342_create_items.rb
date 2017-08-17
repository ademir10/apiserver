class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.references :product, foreign_key: true
      t.references :desk_order, foreign_key: true

      t.timestamps
    end
  end
end
