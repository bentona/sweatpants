require 'spec_helper'
require 'fakeredis'

describe Sweatpants::RedisQueue do

  let(:request_1) { ({foo: "bar", baz: "buzz"})}
  let(:request_2) { ({some: "stuff"})}
  let(:request_3) { ({other: "things"})}
  let(:request_4) { ({fizz: 'bang'})}

  describe '#initialize' do
    it "works" do
      Sweatpants::RedisQueue.new
    end
  end
  
  describe '#enqueue' do
    
    before :each do
      Redis.new.flushall
      @queue = Sweatpants::RedisQueue.new
    end

    it "can enqueue requests (json strings)" do
      @queue.enqueue(request_1)
      @queue.enqueue(request_2)
      expect(@queue.peek(2)).to eq([request_1.to_json, request_2.to_json])
    end
  end

  describe '#dequeue' do

    before :each do
      Redis.new.flushall
      @queue = Sweatpants::RedisQueue.new
    end
    
    it "dequeues all requests by default" do
      @queue.enqueue(request_1)
      @queue.enqueue(request_2)
      expect(@queue.dequeue).to eq([request_1.to_json, request_2.to_json])
    end

    it "dequeues the specified number of requests" do
      @queue.enqueue(request_1)
      @queue.enqueue(request_2)
      @queue.enqueue(request_3)
      @queue.enqueue(request_4)
      expect(@queue.dequeue(1)).to eq([request_1.to_json])
      expect(@queue.dequeue(2)).to eq([request_2.to_json, request_3.to_json])
    end
  end

end