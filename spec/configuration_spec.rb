# spec/mega_lotto/configuration_spec.rb

require "spec_helper"

# client, queue, flush_frequency, trapped_actions, timer

module Sweatpants
  describe Configuration do
    describe "#flush_frequency" do
      it "default value is 1 second" do
        Configuration.new.flush_frequency = 1
      end
    end

    describe "#drawing_count=" do
      it "can set value" do
        config = Configuration.new
        config.flush_frequency = 7
        expect(config.flush_frequency).to eq(7)
      end
    end

    describe ".reset" do
      before :each do
        Sweatpants.configure do |config|
          config.flush_frequency = 5
        end
      end

      it "resets the configuration" do
        Sweatpants.reset
        config = Sweatpants.configuration
        expect(config.flush_frequency).to eq(1)
      end
    end
  end
end