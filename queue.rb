require 'redis'

class SweatpantsQueue < Array
  def initialize
    super
  end

  def enqueue request
    true if self << request
  end

  def dequeue count=nil
    count.nil? ? pop(self.size) : pop(count)
  end

  def multi_enqueue requests
    requests.each do |request|
      enqueue request
    end
  end

  def contents
    self
  end
end

class RedisSweatpantsQueue < SweatpantsQueue
  def initialize redis
    @redis_list = 'sweatpants_queue'
    @redis = Redis.new#(:host => "10.0.1.1", :port => 6380)
    @redis.select '3'
  end

  def enqueue request
    @redis.rpush @list_name, request
  end

  def dequeue count=nil
    list_length = @redis.llen(@list_name)
    multi_pop (count.nil? ? list_length : count)
  end

  private
  def multi_pop count
    @redis.multi {
      peek count
      @redis.ltrim(@list_name, count, -1)
    }[0]
  end

  def peek count
    @redis.lrange(@list_name, 0, count - 1)
  end
end


