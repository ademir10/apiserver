class FormPayment < ApplicationRecord
  belongs_to :desk_order, optional: true
  validates :type_payment, presence: true
  has_many :receipts
end
