require 'spec_helper'

module Sweatpants
  describe Client do
    let(:request_1){ {index: "matches", type: 'MyIndex', body: {stuff: 'some stuff'} } }


    describe '#new' do
      it "instantiates with a client and queue" do
        sweatpants = Sweatpants::Client.new
        sweatpants.instance_variable_get(:@client).should_not be_nil
        sweatpants.instance_variable_get(:@queue).should be_a Sweatpants::SimpleQueue
      end
    end

    describe '#configure' do
      before do
        Sweatpants.configure do |config|
          config.flush_frequency = 5
        end
      end

      it "has a flush frequency of 5 seconds" do
        client = Sweatpants::Client.new
        expect(client.flush_frequency).to eq(5) 
      end
    end

    describe '#flush' do
      before do
        @es_client = double('es_client')
        allow(@es_client).to receive(:bulk)
        @jobs = [{here: 'are'}, {some: 'jobs'}]
        Sweatpants.configure do |config|
          config.client = @es_client
          config.flush_frequency = 10000
        end
        @client = Sweatpants::Client.new
        @client.queue.enqueue @jobs[0]
        @client.queue.enqueue @jobs[1]
        @client.flush
      end

      it 'sends the requests with client.bulk' do
        expect(@es_client).to have_received(:bulk).with(@jobs)
      end

    end

    describe 'traps requests' do
      
      before :each do
        Sweatpants.reset
        fake_client = double(search: nil, index: nil)
        Sweatpants.configure do |config|
          config.client = fake_client
          config.flush_frequency = 10000
        end
        @sweatpants = Sweatpants::Client.new()
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
end