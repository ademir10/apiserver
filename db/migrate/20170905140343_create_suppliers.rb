class CreateSuppliers < ActiveRecord::Migration[5.1]
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :cep
      t.string :address
      t.string :neighborhood
      t.string :city
      t.string :state
      t.string :phone
      t.string :cellphone
      t.string :cnpj
      t.string :email

      t.timestamps
    end
  end
end
