class DeskOrderBroadCastJob < ApplicationJob
  queue_as :default

  def perform(message)
    @desk_order = DeskOrder.find_by(id: $desk_order_id.to_i)
    ActionCable.server.broadcast "desk_order_channel", message: 'A ' + @desk_order.qrpoint.description.to_s + ' acabou de solicitar a sua conta.'
  end
end
