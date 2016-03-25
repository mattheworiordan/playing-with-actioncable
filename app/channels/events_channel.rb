require 'connection_manager'

class EventsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "connections"
    ConnectionManager.new_connection
    broadcast
  end

  def unsubscribed
    ConnectionManager.connection_gone
    broadcast
  end

  private
  def broadcast
    ActionCable.server.broadcast "connections", { count: ConnectionManager.connected_count }
  end
end
