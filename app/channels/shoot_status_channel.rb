class ShootStatusChannel < ApplicationCable::Channel
  def subscribed
    stream_from "shoot_status_channel"
  end

  def unsubscribed

  end
end
