require 'spec_helper'
require 'stringio'

describe NyanCatFormatter do

  before do
    rspec_bin = $0.split('/').last
    @output = StringIO.new
    if rspec_bin == 'rspec'
      @formatter = NyanCatFormatter.new(@output)
      @example = RSpec::Core::ExampleGroup.describe.example
    else
      formatter_options = OpenStruct.new(:colour => true, :dry_run => false, :autospec => nil)
      @formatter = NyanCatFormatter.new(formatter_options, @output)
      @example = Spec::Example::ExampleProxy.new("should pass")
      @formatter.instance_variable_set(:@example_group, OpenStruct.new(:description => "group"))
    end
    @formatter.start(2)
    sleep(0.1)  # Just to slow it down a little :-)
  end

  describe 'passed, pending and failed' do

    before do
      @formatter.stub!(:tick)
    end

    describe 'example_passed' do

      it 'should call the increment method' do
        @formatter.should_receive :tick
        @formatter.example_passed(@example)
      end

      it 'should relax Nyan Cat' do
        @formatter.example_passed(@example)
        @formatter.nyan_cat.should == [
          '_,------,   ',
          '_|  /\_/\ ',
          '~|_( ^ .^)  ',
          ' ""  "" '
        ].join("\n")
      end

      it 'should update the scoreboard' do
        @formatter.scoreboard.size.should == 4
      end

    end

    describe 'example_pending' do

      it 'should call the tick method' do
        @formatter.should_receive :tick
        @formatter.example_pending(@example)
      end

      it 'should increment the pending count' do
        lambda { @formatter.example_pending(@example)}.
          should change(@formatter, :pending_count).by(1)
      end

      it 'should alert Nyan Cat' do
        @formatter.example_pending(@example)
        @formatter.nyan_cat.should == [
          '_,------,   ',
          '_|  /\_/\ ',
          '~|_( o .o)  ',
          ' ""  "" '
        ].join("\n")
      end

    end

    describe 'example_failed' do

      it 'should call the increment method' do
        @formatter.should_receive :tick
        @formatter.example_failed(@example)
      end

      it 'should increment the failure count' do
        lambda { @formatter.example_failed(@example)}.
          should change(@formatter, :failure_count).by(1)
      end

      it 'should alert Nyan Cat' do
        @formatter.example_failed(@example)
        @formatter.nyan_cat.should == [
          '_,------,   ',
          '_|  /\_/\ ',
          '~|_( o .o)  ',
          ' ""  "" '
        ].join("\n")
      end

      it 'should kill nyan if the specs are finished' do
        @formatter.example_failed(@example)
        @formatter.stub(:finished?).and_return(true)
        @formatter.nyan_cat.should == [
          '_,------,   ',
          '_|  /\_/\ ',
          '~|_( x .x)  ',
          ' ""  "" '
        ].join("\n")
      end

    end
  end

  describe 'tick' do

    before do
      @formatter.stub!(:current).and_return(1)
      @formatter.stub!(:example_count).and_return(2)
      @formatter.tick
    end

    it 'should increment the current' do
      @formatter.current.should == 1
    end

    it 'should store the marks in an array' do
      @formatter.example_results.should include('=')
    end

  end

  describe 'rainbowify' do

    it 'should increment the color index count' do
      lambda { @formatter.rainbowify('=') }.should change(@formatter, :color_index).by(1)
    end

  end

  describe 'highlight' do

    it 'should rainbowify passing examples' do
      @formatter.highlight('=').should == "\e[38;5;154m-\e[0m"
    end

    it 'should mark failing examples as red' do
      @formatter.highlight('*').should == "\e[31m*\e[0m"
    end

    it 'should mark pending examples as yellow' do
      @formatter.highlight('!').should == "\e[33m!\e[0m"
    end

  end

  describe 'start' do

    it 'should set the total amount of specs' do
      @formatter.example_count.should == 2
    end

    it 'should set the current to 0' do
      @formatter.current.should == 0
    end

  end

  describe "#format_duration" do
    it "should return just seconds for sub 60 seconds" do
      @formatter.format_duration(5.3).should eq("5.3 seconds")
    end

    it "should remove that extra zero if it is not needed" do
      @formatter.format_duration(1.0).should eq("1 second")
    end

    it "should plurlaize seconds" do
      @formatter.format_duration(1.1).should eq("1.1 seconds")
    end

    it "add a minute if it is just over 60 seconds" do
      @formatter.format_duration(63.2543456456).should eq("1 minute and 3.25 seconds")
    end

    it "should pluralize minutes" do
      @formatter.format_duration(987.34).should eq("16 minutes and 27.34 seconds")
    end
  end

  describe "example width" do
    [15, 36, 60].each do |n|
      context "for #{n} examples" do
        before { @formatter.start(n) }

        [0.25, 0.5, 0.75].each do |p|
          i = (n * p).to_i
          before { i.times { @formatter.tick } }

          context "when in example #{i}" do
            it "should return 1 as the example width" do
              @formatter.example_width.should == 1
            end
          end
        end
      end
    end
  end
end
