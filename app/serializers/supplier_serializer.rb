class SupplierSerializer < ActiveModel::Serializer
  attributes :id, :name, :cep, :address, :neighborhood, :city, :state, :phone, :cellphone, :cnpj, :email
end
