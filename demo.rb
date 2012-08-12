require_relative 'spec/spec_helper'
require 'stringio'

describe NyanCatFormatter do

  before do
    @output = StringIO.new
    @formatter = NyanCatFormatter.new(@output)
    @formatter.start(2)
    @example = RSpec::Core::ExampleGroup.describe.example

    @samples = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

    sleep(0.1)  # Just to slow it down a little :-)
  end

  100.times do |index|
    it "should perform passing specs" do
      @formatter.current.should == @samples.sample
    end

    it "should perform pending specs" do
      if @samples.sample == 1
        pending
      end
    end
  end

end
