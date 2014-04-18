require 'redis'

module Sweatpants
  class SimpleQueue < Array
    def initialize
      super
    end

    def enqueue request
      true if self << request
    end

    def dequeue count=nil
      count.nil? ? pop(self.size) : pop(count)
    end

    def peek
      self
    end
  end
end

module Sweatpants
  class RedisQueue
    attr_reader :redis
    
    def initialize params = {}
      @list_name = params[:list]
      @redis = Redis.new(host: params[:host], port: params[:port])
      @redis.select params[:database]
    end

    def enqueue request
      @redis.rpush @list_name, request.to_json
    end

    def dequeue count=nil
      count = @redis.llen(@list_name) unless count
      multi_pop count
    end

    def multi_pop count
      items = @redis.multi {
        peek count
        @redis.ltrim(@list_name, count, -1)
      }[0]
      items
    end

    def flushall
      @redis.flushall
    end

    def peek count = nil
      count = @redis.llen(@list_name) unless count
      @redis.lrange(@list_name, 0, count - 1)
    end
  end
end

