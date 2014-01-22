require 'json'
require './queue.rb'
require './workers.rb'

class Sweatpants
  def initialize queue, worker
    config
    @queue = queue
    @worker = worker
  end

  def config
    @batch_size = 100
  end

  def enqueue job
    @queue.enqueue job
  end

  def tick
    jobs = @queue.dequeue @batch_size
    begin
      @worker.process(jobs)
    rescue SweatpantsWorkerException => swe
      @queue.multi_enqueue jobs
      raise swe
    end
  end
end

=begin
class SweatJob
  def path
    request.fullpath
  end

  def body
    JSON.parse(request.body.read)
  end
end
=end