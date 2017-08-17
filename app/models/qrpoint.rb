class Qrpoint < ApplicationRecord
  belongs_to :desk_order, optional: true
end
