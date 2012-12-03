gem 'minitest'
require 'minitest/autorun'
require_relative 'lib/dickinson_twitter'

describe PoemPicker do 
  before do
    @instance = PoemPicker.new 100
  end

  describe "instance of PoemPicker" do
    it "will initially be empty" do
      @instance.poem.must_be_nil
    end

    it "will have a poem 'Hope is a thing with feather' after calling pick" do 
      @instance.pick 
      @instance.poem.wont_be_empty
      @instance.poem.must_match(/Hope/)
    end
  end
end
