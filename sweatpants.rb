require './queue.rb'
require 'elasticsearch'

class Sweatpants
  def initialize *args
    # flush frequency option
    @client = Elasticsearch::Client.new *args
    @queue = SweatpantsQueue.new
    self.spawn_tick_thread
  end

  def spawn_tick_thread
    Thread.new do
      while true do
        self.tick
        sleep 1
      end
    end
  end

  def tick
    begin
      flush
    rescue Exception => e
      # we never want an exception here to kill our tick thread.
      $stderr.puts e
    end
  end

  def trap_request? method_name, *args
    methods_to_trap = [:index, :update]
    methods_to_trap.include?(method_name)
  end

  def method_missing(method_name, *args, &block)
    puts "#{method_name} called on Sweatpants client"
    if trap_request?(method_name, *args)
      enqueue method_name, *args
    else
      @client.send(method_name, *args)
    end
  end

  def enqueue method, *args
    formatted_request = Sweatpants.bulk_format method, *args
    @queue.enqueue formatted_request
  end

  def flush
    puts "flushing queue"
    # @client.bulk @queue.all
  end
end