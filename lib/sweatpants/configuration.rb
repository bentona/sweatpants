module Sweatpants
  class Configuration
    attr_accessor :flush_frequency

    def initialize
      @flush_frequency = 1
      @queue = Sweatpants::SimpleQueue.new
      @flush_frequency = sweatpants_params[:flush_frequency] || 1
      @actions_to_trap = sweatpants_params[:actions_to_trap] || [:index]
      @timer = Sweatpants::Timer.new(@flush_frequency)
      @timer.on_tick { flush }
    end

  end
end