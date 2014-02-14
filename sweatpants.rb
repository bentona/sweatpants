require './queue.rb'
require 'elasticsearch'

class ElasticsearchRequest
  def initialize params
    @type = params[:type]
    @index = params[:index]
    @id = params[:id]
  end

  def to_bulk
    [bulk_header, @body].join("\n")
  end

  def bulk_header
    throw Exception "bulk_header not defined for #{this.class}"
  end

  def self.create method_name, params
    klass = case method_name
    when :index
      ElasticsearchIndexRequest
    else
      nil
    end
    klass.new(params) if klass
  end

  protected :initialize
end

class ElasticsearchIndexRequest < ElasticsearchRequest
  def initialize params
    super(params)
    @body = params[:body]
  end

  def bulk_header
    { index: { _index: @index, _type: @type, _id: @id } }
  end
end


class Sweatpants

  CLIENT =

  def initialize es_params, sweatpants_params = {}
    # flush frequency option
    @client = Elasticsearch::Client es_params
    @queue = sweatpants_params[:queue] || SweatpantsQueue.new
    @flush_frequency = sweatpants_params[:flush_frequency] || 1
    @actions_to_trap = sweatpants_params[:actions_to_trap] || [:index]
    @tick_thread = self.spawn_tick_thread
  end

  def spawn_tick_thread
    @tick_thread = Thread.new do
      while true do
        self.tick
        sleep @flush_frequency
      end
    end
  end

  def join # for testing
    @tick_thread.join
  end

  def tick
    begin
      flush
    rescue Exception => e
      # we never want an exception here to kill our tick thread.
      $stderr.puts e
    end
  end

  def trap_request? action, *args
    es_arguments = args[0]
    sweatpants_arguments = args[1]
    @actions_to_trap.include?(action) || sweatpants_arguments[:immediate]
  end

  def method_missing(method_name, *args, &block)
    puts "#{method_name} called on #{self.class} client"
    if trap_request?(method_name, *args)
      delay(method_name, *args)
    else
      @client.send(method_name, *args)
    end
  end

  def delay method_name, *args
    request = ElasticsearchRequest.create method_name, args[0]
    @queue.enqueue request.to_bulk
    'ok'
  end

  def flush
    #puts "flushing queue"
    #@client.bulk @queue.dequeue
  end
end