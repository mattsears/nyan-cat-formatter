# frozen_string_literal: true

require 'nyan_cat_formatter'
require 'nyan_cat_format/verbose'
require 'nyan_cat_format/insta_fail'
require 'nyan_cat_format/helpers'

NyanCatInstaFailFormatter = Class.new(NyanCatFormatter) do
  extend NyanCatFormat::Helpers
  include NyanCatFormat::InstaFail

  if rspec_3_or_greater?
    RSpec::Core::Formatters.register(self, :example_passed, :example_pending,
                                     :example_failed, :start_dump, :start)
  end
end
