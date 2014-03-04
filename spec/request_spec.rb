require 'spec_helper'
require './request.rb'

describe QueuedRequest do
  before :each do
    @params_1 = {
      type: "MyType",
      index: "users",
      id: 123,
      body: {some: 'stuff'}
    }
    @request_1 = QueuedRequest.new :index, @params_1
  end

  describe '#initialize' do
    it 'initializes with proper params' do
      QueuedRequest.new :index, @params_1
    end

    it 'raises when initialized without proper params' do
      expect{QueuedRequest.new}.to raise_error
      expect{QueuedRequest.new :index }.to raise_error
    end
  end

  describe '#to_bulk' do
    xit 'properly formats a bulk request' do
      puts @request_1.to_bulk.to_s
      expect().to eq('')
    end
  end
end