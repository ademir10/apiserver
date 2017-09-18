class Product < ApplicationRecord
  belongs_to :category
  belongs_to :item, optional: true
  validates :name, :value, :category_id, :description, :local_print, presence: true
  #para o upload de imagens
  validates :image, file_size: { less_than_or_equal_to: 500.kilobytes, message: 'deve ter até %{count} de tamanho' },
                     file_content_type: { allow: ['image/jpeg', 'image/gif', 'image/png'] }

  mount_uploader :image, ImageUploader
end
