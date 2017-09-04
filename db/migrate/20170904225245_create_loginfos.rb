class CreateLoginfos < ActiveRecord::Migration[5.1]
  def change
    create_table :loginfos do |t|
      t.string :employee
      t.string :task

      t.timestamps
    end
  end
end
