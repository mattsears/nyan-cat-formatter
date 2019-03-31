# frozen_string_literal: true

require 'nyan_cat_formatter'
require 'nyan_cat_format/verbose'
require 'nyan_cat_format/helpers'

NyanCatVerboseFormatter = Class.new(NyanCatFormatter) do
  extend NyanCatFormat::Helpers
  include NyanCatFormat::Verbose

  if rspec_3_or_greater?
    RSpec::Core::Formatters.register(self, :example_passed, :example_pending,
                                     :example_failed, :start_dump, :start)
  end
end
