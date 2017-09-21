class CreateConfigs < ActiveRecord::Migration[5.1]
  def change
    create_table :configs do |t|
      t.string :interval_print
      t.string :printer1
      t.string :printer2
      t.string  :razao
      t.string  :nome_fantasia
      t.string  :cnpj
      t.string  :cep
      t.string  :endereco
      t.string  :numero
      t.string  :bairro
      t.string  :cidade
      t.string  :uf
      t.string  :telefone
      t.string  :email
      t.string  :inscricao
      t.string  :url_server_test
      t.string  :token_test
      t.string  :url_server_production
      t.string  :token_production
      t.string  :port, :integer
      t.string  :sleep, :integer
      t.string  :check_date, :boolean
      t.string  :expiration_date, :date
      t.string  :check_env
      t.string :site, :site

      t.timestamps
    end
  end
end
