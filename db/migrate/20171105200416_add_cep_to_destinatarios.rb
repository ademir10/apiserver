class AddCepToDestinatarios < ActiveRecord::Migration[5.1]
  def change
    add_column :destinatarios, :cep, :string
  end
end
