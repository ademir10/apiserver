class DeskOrder < ApplicationRecord
  # para poder permitir a exclusão da invoice mesmo tendo itens ou não
  has_many :items, dependent: :destroy
  has_many :qrpoints
end
