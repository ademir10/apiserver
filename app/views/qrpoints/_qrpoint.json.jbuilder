json.extract! qrpoint, :id, :description, :qrcode, :status, :created_at, :updated_at
json.url qrpoint_url(qrpoint, format: :json)
