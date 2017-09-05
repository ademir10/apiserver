json.array!(@payments) do |payment|
  json.extract! payment, :id, :doc_number, :description, :due_date, :payment_date, :installments, :value_doc, :type_doc, :form_payment, :status, :supplier_id
  json.url payment_url(payment, format: :json)
end
