class DeskOrder < ApplicationRecord
  # para poder permitir a exclusão da invoice mesmo tendo itens ou não
  has_many :items, dependent: :destroy
  belongs_to :qrpoint, optional: true
  belongs_to :form_payment, optional: true
  belongs_to :destinatario, optional: true
  attr_accessor :environment

  #chama o job depois que é fechada a mesa
  after_update_commit :after_close_desk_order
  def after_close_desk_order
    if status == 'Solicita o fechamento'
      $desk_order_id = id
      DeskOrderBroadCastJob.perform_later self
    elsif status == 'Finalizada'
      PrinterBroadcastJob.perform_later self
    end
  end

end
