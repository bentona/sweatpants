require 'sinatra'
require 'sinatra/multi_route'
require 'redis'
require 'json'

REDIS_DB = '3'
REDIS_LIST_NAME = 'sweatpants_test'

redis = Redis.new#(:host => "10.0.1.1", :port => 6380)
redis.select REDIS_DB

set :port, 9203

class RedisSweatStore
  def initialize redis
    @list_name = 'sweatpants'
    @redis = redis
  end

  def queue request
    @redis.rpush @list_name, request
  end

  def dequeue count=nil
    list_length = @redis.llen(REDIS_LIST_NAME)
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

class SweatStore
  def initialize
    @store = []
  end

  def queue request
    @store << request
  end

  def dequeue count=nil
    count.nil? ? @store.pop(@store.size) : @store.pop(count)
  end
end

store = SweatStore.new

route :get, :post, :put, '*' do
  # p request
  request_to_store = "#{es_metadata}\n#{es_body}"
  store.queue_request request_to_store
end

helpers do
  def es_metadata
    # POST /users/user/68782
    path = request.env['REQUEST_URI'].split('/').reject(&:empty?)
    if path.size == 3
      { index: { _index: path[0], _type: path[1], _id: path[2] } }
    else
      nil
    end
  end

  def es_body
    JSON.parse(request.env['rack.request.form_vars'])
  end
end

