class Destinatario < ApplicationRecord
  attr_accessor :type_save
  belongs_to :desk_order, optional: true
  validates :nome, :cep, :endereco, :numero, :bairro, :cidade, :celular, presence: true
  validates :celular, uniqueness: true
end
