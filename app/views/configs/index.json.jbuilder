json.array!(@configs) do |config|
  json.extract! config, :id, :razao, :nome_fantasia, :cnpj, :cep, :endereco, :numero, :bairro, :cidade, :uf, :telefone, :inscricao, :check_date, :expiration_date, :filename, :content_type, :file_contents
  json.url config_url(config, format: :json)
end
