class PrinterBroadcastJob < ApplicationJob
  queue_as :default

  def perform(mensagem)
    ActionCable.server.broadcast "printer_channel", message: 'Glória a Deus!!!'
  end
end
