class DestinatarioSerializer < ActiveModel::Serializer
  attributes :id, :nome, :endereco, :numero, :bairro, :complemento, :cidade, :celular, :email, :obs
end
