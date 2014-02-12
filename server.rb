require 'sinatra'
require 'sinatra/multi_route'
require './sweatpants.rb'
require './workers.rb'

queue = SweatpantsQueue.new
worker = DummyWorker.new
sweatpants = Sweatpants.new queue, worker

set :port, 9203

route :get, :post, '*' do
  path = request.fullpath
  body = JSON.parse(request.body.read)
  sweatpants.enqueue "#{path}\n#{body}\n"
end

Thread.new do
  while true do
    sweatpants.tick
    sleep(1)
    puts 'tick'
  end
end
