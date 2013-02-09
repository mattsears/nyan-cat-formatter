require 'spec_helper'
require 'stringio'
require 'nyan_cat_wide_formatter'

describe NyanCatWideFormatter do
  before do
    @output = StringIO.new
    @formatter = NyanCatWideFormatter.new(@output)
  end

  describe "cat situation" do
    before do
      @formatter.stub!(:terminal_width).and_return(100)
      @formatter.stub!(:cat_length).and_return(11)
      @whole_net_width = 100 - 2*2 - 6 - 11
    end

    context "for 35 examples" do
      before do
        @formatter.start(35)
      end

      it "should calculate the net width for example 3" do
        @formatter.net_width_for(3).should == (@whole_net_width * 3.0 / 35.0).round
      end

      it "should calculate the net width for example 30" do
        @formatter.net_width_for(5).should == (@whole_net_width * 5.0 / 35.0).round
      end
    end

    context "for 50 examples" do
      before { @formatter.start(50) }

      it "should calculate the net width for example 1" do
        @formatter.net_width_for(1).should == (@whole_net_width * 1.0 / 50.0).round
      end

      it "should calculate the net width for example 25" do
        @formatter.net_width_for(25).should == (@whole_net_width * 25.0 / 50.0).round
      end
    end
  end
end
