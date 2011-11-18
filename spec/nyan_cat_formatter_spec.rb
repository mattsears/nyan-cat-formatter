require 'spec_helper'
require 'stringio'

describe NyanCatFormatter do

  before do
    @output = StringIO.new
    @formatter = NyanCatFormatter.new(@output)
    @formatter.start(2)
    @example = RSpec::Core::ExampleGroup.describe.example
    sleep(0.2)  # Just to slow it down a little :-)
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
        @formatter.nyan_cat.should == <<-CAT
_,------,
_|   /\\_/\\
~|__( ^ .^)
_""  ""
CAT
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
        @formatter.nyan_cat.should == <<-CAT
_,------,
_|   /\\_/\\
~|__( o .o)
_""  ""
CAT
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
        @formatter.nyan_cat.should == <<-CAT
_,------,
_|   /\\_/\\
~|__( o .o)
_""  ""
CAT
      end

    end
  end

  describe 'tick' do

    before do
      @formatter.stub!(:current).and_return(1)
      @formatter.stub!(:example_count).and_return(2)
      @formatter.tick
    end

    it 'should change title' do
      @formatter.title.should == '  1/2'
    end

    it 'should calculate the percentage done' do
      @formatter.percentage.should == 50
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

end
