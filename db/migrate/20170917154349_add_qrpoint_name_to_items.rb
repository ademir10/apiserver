class AddQrpointNameToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :qrpoint_name, :string
  end
end
