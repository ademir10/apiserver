class Category < ApplicationRecord
  has_many :products
  validates :name, :description, presence: true
  #para o upload de imagens
  validates :image, file_size: { less_than_or_equal_to: 500.kilobytes, message: 'deve ter até %{count} de tamanho' },
                     file_content_type: { allow: ['image/jpeg', 'image/gif', 'image/png'] }

  mount_base64_uploader :image, ImageUploader

end
