# frozen_string_literal: true

require 'nyan_cat_formatter/common'

rspec_bin = $PROGRAM_NAME.split('/').last
if rspec_bin == 'spec'
  ['spec', 'spec/runner/formatter/base_text_formatter', 'nyan_cat_formatter/rspec1'].each { |f| require f }
  formatter = RSpec1
else
  require 'rspec/core/formatters/base_text_formatter'
  if Gem::Version.new(RSpec::Core::Version::STRING).release >= Gem::Version.new('3.0.0')
    require 'nyan_cat_formatter/rspec3'
    formatter = RSpec3
  else
    require 'nyan_cat_formatter/rspec2'
    formatter = RSpec2
  end
end

NyanCatFormatter = formatter
