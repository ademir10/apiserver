class Receipt < ApplicationRecord
  belongs_to :form_payment, optional: true
end
