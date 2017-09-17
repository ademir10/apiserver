class Item < ApplicationRecord
  belongs_to :product
  belongs_to :desk_order

  #para salvar o nome do produto quando é feito uma adição de produto na mesa pelo balcão e naõ pelo produto
  before_create :insert_product_name, :if => lambda { |item| item.name_prod.nil? }
  def insert_product_name
    self.name_prod = self.product.name
    self.qrpoint_name = self.desk_order.qrpoint.description
  end
  #action criadas para fazer a baixa dos produtos no estoque e voltar os produtos quando for feito uma exclusão
  after_create :remove_from_stock
  after_destroy :return_to_stock

  #faz a baixa do produto
  def remove_from_stock
    @product = Product.find_by_id(product_id)
    if @product.check_stock == !false
    product.qnt -= self.qnt
    product.save
    end
  end
  #retorna o produto para o estoque quando acontece uma exclusão
  def return_to_stock
    @product = Product.find_by_id(product_id)
    if @product.check_stock == !false
    product.qnt += self.qnt
    product.save
    end
  end
end
