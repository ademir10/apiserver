class CreateQrpoints < ActiveRecord::Migration[5.1]
  def change
    create_table :qrpoints do |t|
      t.string :description
      t.string :qrcode
      t.string :status

      t.timestamps
    end
  end
end
