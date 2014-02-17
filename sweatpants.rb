require './queue.rb'
require './request.rb'
require 'elasticsearch'

class Sweatpants

  def initialize es_params = {}, sweatpants_params = {}
    @client = Elasticsearch::Client.new es_params
    @queue = sweatpants_params[:queue] || SweatpantsQueue.new
    @flush_frequency = sweatpants_params[:flush_frequency] || 1
    @actions_to_trap = sweatpants_params[:actions_to_trap] || [:index]
    @tick_thread = self.spawn_tick_thread
  end

  def spawn_tick_thread
    ## alternatively, begin; sleep 1 && tick; rescue; ensure spawn_tick;
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
  end

  def flush
    puts "flushing queue"
    puts @queue.contents.join("\n")
    puts "\n"

    #@client.bulk @queue.dequeue
  end
end