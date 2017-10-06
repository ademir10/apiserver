class CreateCfops < ActiveRecord::Migration[5.1]
  def change
    create_table :cfops do |t|
      t.integer :codigo
      t.string :descricao

      t.timestamps
    end
  end
end
