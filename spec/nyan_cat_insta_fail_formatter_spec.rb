require 'spec_helper'
require 'stringio'
require 'nyan_cat_insta_fail_formatter'

describe NyanCatInstaFailFormatter do
  before(:all) do
    @output = StringIO.new
    @formatter = described_class.new(@output)
  end

  before(:each) do
    @formatter.start(1)
  end

  it 'displays failed tests immediately' do
    example = double :example
    expect(example).to receive( :fully_formatted ).and_return( "FAIL" )
    @formatter.example_failed(example)
    expect( @output.string ).to include('FAIL')
  end

end
