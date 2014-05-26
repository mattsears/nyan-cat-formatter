# -*- coding: utf-8 -*-
require 'nyan_cat_formatter'
require 'nyan_cat_format/wide'

NyanCatWideFormatter = Class.new(NyanCatFormatter) do
  include NyanCatFormat::Wide

  rspec_3_or_greater = Gem::Version.new(RSpec::Core::Version::STRING).release >= Gem::Version.new('3.0.0')

  RSpec::Core::Formatters.register(self, :example_passed, :example_pending,
    :example_failed, :start_dump, :start) if rspec_3_or_greater
end
