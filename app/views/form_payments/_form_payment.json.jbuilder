json.extract! form_payment, :id, :type_payment, :created_at, :updated_at
json.url form_payment_url(form_payment, format: :json)
