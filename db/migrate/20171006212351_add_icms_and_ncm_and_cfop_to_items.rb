class AddIcmsAndNcmAndCfopToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :cfop, :integer
    add_column :items, :codigo_ncm, :integer
    add_column :items, :icms_situacao_tributaria, :string
    add_column :items, :ipi_situacao_tributaria, :integer
  end
end
