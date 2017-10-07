class AddUrlsToDeskOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :desk_orders, :url_danfe, :string
    add_column :desk_orders, :url_xml, :string
    add_column :desk_orders, :justificativa_cancelamento, :text
    add_column :desk_orders, :caminho_xml_cancelamento, :string
  end
end
