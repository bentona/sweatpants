require 'spec_helper'
require './queue.rb'
require 'fakeredis'

describe RedisSweatpantsQueue do

  describe '#initialize' do
    it "initializes with default params" do
      queue = RedisSweatpantsQueue.new
    end

    it "initializes with a specified redis client" do
      queue = RedisSweatpantsQueue.new(redis: Redis.new)
    end

    xit "initializes with a specified redis client and list" do
    end
  end
  
  describe '#enqueue' do
    xit "does stuff" do
    end
  end

  describe '#dequeue' do
    xit "does other stuff" do
    end
  end

end