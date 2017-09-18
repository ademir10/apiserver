class Qrpoint < ApplicationRecord
  belongs_to :desk_order, optional: true
  validates :description, :qrcode, uniqueness: true
  validates :description, :qrcode, presence: true
end
