json.extract! supplier, :id, :name, :cep, :address, :neighborhood, :city, :state, :phone, :cellphone, :cnpj, :email, :created_at, :updated_at
json.url supplier_url(supplier, format: :json)
