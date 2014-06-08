# -*- coding: utf-8 -*-
require 'nyan_cat_formatter'
require 'nyan_cat_format/music'
require 'nyan_cat_format/helpers'

NyanCatMusicFormatter = Class.new(NyanCatFormatter) do
  extend NyanCatFormat::Helpers
  include NyanCatFormat::Music

  RSpec::Core::Formatters.register(self, :example_passed, :example_pending,
    :example_failed, :start_dump, :start) if rspec_3_or_greater?
end
