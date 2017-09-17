class CreateConfigs < ActiveRecord::Migration[5.1]
  def change
    create_table :configs do |t|
      t.string :interval_print
      t.string :printer1
      t.string :printer2

      t.timestamps
    end
  end
end
