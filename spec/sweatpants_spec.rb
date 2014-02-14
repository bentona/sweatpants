#require 'spec_helper'

require './sweatpants.rb'

describe Sweatpants do
  describe '#new' do
    it "instantiates with a client and queue" do
      sweatpants = Sweatpants.new
      sweatpants.instance_variable_get(:@client).should_not be_nil
      sweatpants.instance_variable_get(:@queue).should be_a SweatpantsQueue
    end
  end
end