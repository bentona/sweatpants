# mostly taken from http://brandonhilkert.com/blog/ruby-gem-configuration-patterns
module Sweatpants
  class Configuration
    attr_accessor :flush_frequency, :queue, :actions_to_trap, :client

    def initialize
      @flush_frequency = 1
      @queue_type = :redis
      @actions_to_trap = [:index]
      @client = Elasticsearch::Client.new
      @redis_config = {
        host: 'localhost',
        port: 6379,
        list: 'sweatpants_queue',
        database: 3
      }
    end

    def queue
      case @queue_type
      when :redis
        Sweatpants::RedisQueue.new(@redis_config)
      else
        Sweatpants::SimpleQueue.new
      end
    end

  end
end