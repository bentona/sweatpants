require 'spec_helper'

describe Sweatpants do
  let(:request_1){ {index: "matches", type: 'MyIndex', body: {stuff: 'some stuff'} } }

  describe '#new' do
    it "instantiates with a client and queue" do
      sweatpants = Sweatpants.new
      sweatpants.instance_variable_get(:@client).should_not be_nil
      sweatpants.instance_variable_get(:@queue).should be_a SweatpantsQueue
    end
  end

  describe 'traps requests' do
    
    before :each do
      fake_client = double(search: nil, index: nil)
      @sweatpants = Sweatpants.new({}, {client: fake_client, flush_frequency: 10000})
    end

    it "traps an index request" do
      @sweatpants.index(request_1)
      expect(@sweatpants.queue).to have(1).item
    end

    it "doesn't trap a search request" do
      @sweatpants.search(request_1)
      expect(@sweatpants.client).to have_received(:search).with(request_1)
      expect(@sweatpants.queue).to have(0).items
    end

    it "doesn't trap a request marked as immediate" do
      @sweatpants.index(request_1, {immediate: true})
      expect(@sweatpants.queue).to have(0).items
      expect(@sweatpants.client).to have_received(:index).with(request_1)
    end
  end
end