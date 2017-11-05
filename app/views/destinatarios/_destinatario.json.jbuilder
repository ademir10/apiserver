json.extract! destinatario, :id, :nome, :endereco, :numero, :bairro, :complemento, :cidade, :celular, :email, :obs, :created_at, :updated_at
json.url destinatario_url(destinatario, format: :json)
