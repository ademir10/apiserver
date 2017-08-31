class Item < ApplicationRecord
  belongs_to :product
  belongs_to :desk_order

  #para salvar o nome do produto quando é feito uma adição de produto na mesa pelo balcão e naõ pelo produto
  before_create :insert_product_name, :if => lambda { |item| item.name_prod.nil? }
  def insert_product_name
    self.name_prod = self.product.name
  end
end
