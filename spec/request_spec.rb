require 'spec_helper'

describe QueuedRequest do

  let(:params_1) { { type: "MyType", index: "users", id: 123, body: {some: 'stuff'} } }
  let(:request_1) { QueuedRequest.new :index, params_1 }

  describe '#initialize' do
    it 'initializes with proper params' do
      QueuedRequest.new :index, params_1
    end

    it 'raises when initialized without proper params' do
      expect{QueuedRequest.new}.to raise_error
      expect{QueuedRequest.new :index }.to raise_error
    end
  end

  describe '#to_bulk' do
    it 'properly formats a bulk request' do
      expect(request_1.to_bulk).to eq("{\"index\":{\"_index\":\"users\",\"_type\":\"MyType\"},\"id\":123}\n{\"some\":\"stuff\"}")
    end
  end
end