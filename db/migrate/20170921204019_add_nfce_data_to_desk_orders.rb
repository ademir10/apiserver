class AddNfceDataToDeskOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :desk_orders, :cpf_cnpj_nfce, :string
    add_column :desk_orders, :email_nfce, :string
    add_column :desk_orders, :forma_pagamento_nfce, :string
    add_column :desk_orders, :bandeira_operadora, :integer
    add_column :desk_orders, :informacoes_adicionais_contribuinte, :text
  end
end
