json.extract! receipt, :id, :doc_number, :description, :due_date, :receipt_date, :installments, :value_doc, :form_receipt, :desk_order_id, :status, :created_at, :updated_at
json.url receipt_url(receipt, format: :json)
