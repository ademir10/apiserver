class AddTypeAcessToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :type_access, :string
  end
end
