require 'connection_manager'

class EventsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "connections"
    ConnectionManager.new_connection
    @connection_token = generate_connection_token
  end

  def unsubscribed
    ConnectionManager.connection_gone
    ConnectionManager.deregister_callback broadcast_to_current_connection_proc
  end

  def request_count
    broadcast
  end

  def stream_live_count
    ConnectionManager.register_callback broadcast_to_current_connection_proc
    stream_from current_connection_stream
    broadcast_to_current_connection_proc.call
  end

  private
  attr_reader :connection_token

  def broadcast
    ActionCable.server.broadcast "connections", payload
  end

  def generate_connection_token
    SecureRandom.hex(36)
  end

  def current_connection_stream
    "connections:#{connection_token}"
  end

  def payload
    { count: ConnectionManager.connected_count, broadcastAt: Time.new.to_f * 1000 }
  end

  def broadcast_to_current_connection_proc
    @proc ||= Proc.new do
      ActionCable.server.broadcast current_connection_stream, payload
    end
  end
end
