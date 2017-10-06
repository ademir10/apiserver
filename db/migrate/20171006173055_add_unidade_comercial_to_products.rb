class AddUnidadeComercialToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :unidade_comercial, :string
  end
end
