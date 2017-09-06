class DeskOrderChannel < ApplicationCable::Channel
  def subscribed
     stream_from "desk_order_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(variavel_dados)
  end
end
