class AddNameProdToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :name_prod, :string
  end
end
