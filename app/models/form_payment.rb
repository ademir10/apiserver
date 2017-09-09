class FormPayment < ApplicationRecord
  belongs_to :desk_order, optional: true
end
