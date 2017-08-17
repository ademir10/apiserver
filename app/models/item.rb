class Item < ApplicationRecord
  belongs_to :product
  belongs_to :desk_order
end
