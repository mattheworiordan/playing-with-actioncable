class ConnectionManager
  class << self
    def new_connection
      redis.incr "connections"
      trigger_callbacks
    end

    def connection_gone
      redis.decr "connections"
      trigger_callbacks
    end

    def connected_count
      redis.get "connections" || 0
    end

    def register_callback(callback)
      mutex.synchronize do
        callbacks.push(callback)
      end
    end

    def deregister_callback(callback)
      mutex.synchronize do
        callbacks.delete(callback)
      end
    end

    private
    def redis
      @redis ||= Redis.new(:url => Rails.application.secrets.redis_url)
    end

    def mutex
      @mutex ||= Mutex.new
    end

    def callbacks
      @callbacks ||= []
    end

    def trigger_callbacks
      callbacks.each { |callback| callback.call }
    end
  end
end
