module NyanCatFormat
  module Helpers
    def rspec_3_or_greater?
      Gem::Version.new(RSpec::Core::Version::STRING).release >= Gem::Version.new('3.0.0')
    end
  end
end
