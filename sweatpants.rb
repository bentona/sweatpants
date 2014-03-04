require './queue.rb'
require './request.rb'
require 'elasticsearch'
require './timer.rb'

class Sweatpants

  attr_reader :queue, :client

  def initialize es_params = {}, sweatpants_params = {}
    @client = sweatpants_params[:client] || Elasticsearch::Client.new(es_params)
    @queue = sweatpants_params[:queue] || SweatpantsQueue.new
    @flush_frequency = sweatpants_params[:flush_frequency] || 1
    @actions_to_trap = sweatpants_params[:actions_to_trap] || [:index]
    @timer = sweatpants_params[:timer] || Timer.new(@flush_frequency)
    @timer.on_tick { flush }
  end

  #def join # for testing
  #  @tick_thread.join
  #end

  def flush
    begin
      puts "flushing queue"
      puts @queue.contents.join("\n")
      puts "\n"
      #@client.bulk @queue.dequeue
    rescue Exception => e
      # we never want an exception here to kill our tick thread.
      $stderr.puts e
      # use a Logger, maybe @client's?
    end
  end

  def method_missing(method_name, *args, &block)
    puts "#{method_name} called on #{self.class} client"
    if trap_request?(method_name, *args)
      delay(method_name, *args)
    else
      @client.send(method_name, args[0])
    end
  end

  private

  def delay method_name, *args
    request = ElasticsearchRequest.create method_name, args[0]
    @queue.enqueue request.to_bulk
  end

  def trap_request? action, *args
    es_arguments = args[0]
    sweatpants_arguments = args[1] || {}
    @actions_to_trap.include?(action) unless sweatpants_arguments[:immediate]
  end
end