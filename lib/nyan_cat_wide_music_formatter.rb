# frozen_string_literal: true

require 'nyan_cat_formatter'
require 'nyan_cat_format/helpers'
require 'nyan_cat_format/wide'
require 'nyan_cat_format/music'

NyanCatWideMusicFormatter = Class.new(NyanCatFormatter) do
  extend NyanCatFormat::Helpers
  include NyanCatFormat::Wide
  include NyanCatFormat::Music

  if rspec_3_or_greater?
    RSpec::Core::Formatters.register(self, :example_passed, :example_pending,
                                     :example_failed, :start_dump, :start)
  end
end
