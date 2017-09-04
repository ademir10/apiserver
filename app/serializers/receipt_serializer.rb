class ReceiptSerializer < ActiveModel::Serializer
  attributes :id, :doc_number, :description, :due_date, :receipt_date, :installments, :value_doc, :form_receipt, :desk_order_id, :status
end
