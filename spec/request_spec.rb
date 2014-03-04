require 'spec_helper'
require './request.rb'

describe ElasticsearchRequest do
  before :each do
  end

  describe '#initialize' do
    it 'throws an exception when initialized (virtual class)' do
      expect{ ElasticsearchRequest.new({}) }.to raise_error
    end
  end
end