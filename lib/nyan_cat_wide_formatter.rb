# -*- coding: utf-8 -*-
require 'nyan_cat_formatter'
require 'nyan_cat_format/wide'
require 'nyan_cat_format/helpers'

NyanCatWideFormatter = Class.new(NyanCatFormatter) do
  extend NyanCatFormat::Helpers
  include NyanCatFormat::Wide

  RSpec::Core::Formatters.register(self, :example_passed, :example_pending,
    :example_failed, :start_dump, :start) if rspec_3_or_greater?
end
