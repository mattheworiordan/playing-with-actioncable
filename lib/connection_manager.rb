class ConnectionManager
  class << self
    def new_connection
      redis.incr "connections"
    end

    def connection_gone
      redis.decr "connections"
    end

    def connected_count
      redis.get "connections" || 0
    end

    private
    def redis
      @redis ||= Redis.new(:url => Rails.application.secrets.redis_url)
    end
  end
end
