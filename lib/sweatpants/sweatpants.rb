require 'elasticsearch'

module Sweatpants
  class Client

    attr_reader :queue, :client, :actions_to_trap, :flush_frequency

    def initialize es_params = {}, sweatpants_params = {}
      @client = sweatpants_params[:client] || Elasticsearch::Client.new(es_params)
      @queue = sweatpants_params[:queue] || Sweatpants::SimpleQueue.new
      @flush_frequency = sweatpants_params[:flush_frequency] || 1
      @actions_to_trap = sweatpants_params[:actions_to_trap] || [:index]
      @timer = sweatpants_params[:timer] || Sweatpants::Timer.new(@flush_frequency)
      @timer.on_tick { flush }
    end

    #def join; @tick_thread.join; end

    def flush
      begin
        puts @queue.dequeue
        #@client.bulk @queue.dequeue
      rescue Exception => e
        $stderr.puts e  # use a Logger, maybe @client's?
      end
    end

    def method_missing(method_name, *args, &block)
      if trap_request?(method_name, *args)
        delay(method_name, *args)
      else
        @client.send(method_name, args[0])
      end
    end

    private

    def delay method_name, *args
      request = Sweatpants::QueuedRequest.new method_name, args.first
      @queue.enqueue request.to_bulk
    end

    def trap_request? action, *args
      es_arguments = args[0]
      sweatpants_arguments = args[1] || {}
      @actions_to_trap.include?(action) unless sweatpants_arguments[:immediate]
    end
  end
end