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
  # store.queue_request request_to_store
  request.fullpath
end


class SweatJob
  def path
    request.fullpath
  end

  def body
    JSON.parse(request.body.read)
  end
end

class ESHandler
  def initialize
    @es_client = nil
  end

  def process jobs
    content = jobs.map{|job| parse_job(job.path, job.body)}.join("\n")
    # send content to @es_client
  end

  private
  def parse_job path, body
    components = path.split('/').reject(&:empty?)
    return false if path.size != 3
    header = { index: { _index: path[0], _type: path[1], _id: path[2] } }
    "#{header}\n#{body}"
  end
end
