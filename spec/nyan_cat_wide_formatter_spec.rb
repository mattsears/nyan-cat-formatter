require 'spec_helper'
require 'stringio'
require 'nyan_cat_wide_formatter'

describe NyanCatWideFormatter do
  before do
    @output = StringIO.new
    @formatter = NyanCatWideFormatter.new(@output)
  end

  describe "cat situation" do
    before { @formatter.stub!(:terminal_width).and_return(100) }

    [35].each do |n|
      context "for #{n} examples" do
        before do
          @formatter.start(n)
        end

        (0..n).each do |i|
          context "when in example #{i}" do
            before { i.times { @formatter.tick } }

            it "should calculate the example width properly" do
              [2,3].include?(@formatter.example_width(i))
            end
          end
        end
      end
    end
  end
end
