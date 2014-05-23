require "./lib/sweatpants/client"
require "./lib/sweatpants/queue"
require "./lib/sweatpants/timer"
require "./lib/sweatpants/queued_request"
require "./lib/sweatpants/configuration"
require 'sidekiq'

module Sweatpants
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.test_job
    Worker.perform('bob', 3)
  end
end