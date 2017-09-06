class DeskOrder < ApplicationRecord
  # para poder permitir a exclusão da invoice mesmo tendo itens ou não
  has_many :items, dependent: :destroy
  belongs_to :qrpoint, optional: true

  #chama o job depois que é fechada a mesa
  validate :after_close_desk_order
  def after_close_desk_order
    if status == 'Solicita o fechamento'
      $desk_order_id = id
      DeskOrderBroadCastJob.perform_later self
    end
  end

end
