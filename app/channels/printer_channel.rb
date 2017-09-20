class PrinterChannel < ApplicationCable::Channel
  def subscribed
     stream_from "printer_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(variavel_dados)
  end
end
