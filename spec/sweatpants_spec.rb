require 'spec_helper'
require './sweatpants.rb'

describe Sweatpants do
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
      @es_args = {index: "matches", type: 'MyIndex', body: {stuff: 'some stuff'} }
    end

    it "traps an index request" do
      @sweatpants.index(@es_args)
      expect(@sweatpants.queue).to have(1).item
    end

    it "doesn't trap a search request" do
      @sweatpants.search(@es_args)
      expect(@sweatpants.client).to have_received(:search).with(@es_args)
      expect(@sweatpants.queue).to have(0).items
    end

    it "doesn't trap a request marked as immediate" do
      @sweatpants.index(@es_args, {immediate: true})
      expect(@sweatpants.queue).to have(0).items
      expect(@sweatpants.client).to have_received(:index).with(@es_args)
    end
  end
end