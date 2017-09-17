class Qrpoint < ApplicationRecord
  belongs_to :desk_order, optional: true
  validates :description, :qrcode, uniqueness: true
end
