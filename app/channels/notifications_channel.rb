class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifications"
    ActionCable.server.broadcast "notifications", "user subscribed on Notifications"
  end

  def unsubscribed
    ActionCable.server.broadcast "notifications", "user unsubscribed on Notifications"
  end
end
