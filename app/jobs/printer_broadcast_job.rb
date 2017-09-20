class PrinterBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast "printer_channel", message: 'Glória a Deus!!!'
  end
end
