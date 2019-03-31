# frozen_string_literal: true

require 'nyan_cat_formatter'
require 'nyan_cat_format/music'
require 'nyan_cat_format/helpers'

NyanCatMusicFormatter = Class.new(NyanCatFormatter) do
  extend NyanCatFormat::Helpers
  include NyanCatFormat::Music

  if rspec_3_or_greater?
    RSpec::Core::Formatters.register(self, :example_passed, :example_pending,
                                     :example_failed, :start_dump, :start)
  end
end
