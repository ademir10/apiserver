class CreateDestinatarios < ActiveRecord::Migration[5.1]
  def change
    create_table :destinatarios do |t|
      t.string :nome
      t.string :endereco
      t.string :numero
      t.string :bairro
      t.string :complemento
      t.string :cidade
      t.string :celular
      t.string :email
      t.text :obs

      t.timestamps
    end
  end
end
