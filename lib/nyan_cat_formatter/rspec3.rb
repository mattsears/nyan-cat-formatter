require "rspec/core/formatters/base_text_formatter"
require 'ostruct'

class RSpec3 < RSpec::Core::Formatters::BaseTextFormatter
  include NyanCat::Common

  RSpec::Core::Formatters.register self, :example_passed, :example_pending,
    :example_failed, :start_dump, :start

  def initialize(output)
    super(output)
  end

  def start(notification)
    # TODO: Lazy fix for specs.
    if notification.kind_of?(Fixnum)
      super(OpenStruct.new(:count => notification))
    else
      super(notification)
    end

    @current = @color_index = @passing_count = 0
    @example_results = []
  end

  def example_passed(notification)
    tick PASS
  end

  def example_pending(notification)
    if notification.respond_to?(:example)
      super(notification)
    else
      super(OpenStruct.new(example: notification))
    end

    @pending_count += 1

    tick PENDING
  end

  def example_failed(notification)
    # TODO: Lazy fix for specs
    if notification.respond_to?(:example)
      super(notification)
    else
      super(OpenStruct.new(example: notification))
    end

    @failure_count += 1
    tick FAIL
  end

  def start_dump(notification)
    @current = @example_count
  end

  def dump_summary(notification)
    duration      = notification.duration
    failure_count = notification.failure_count
    dump_profile if profile_examples? && failure_count == 0
    summary = "\nYou've Nyaned for #{format_duration(duration)}\n".split(//).map { |c| rainbowify(c) }
    output.puts summary.join
    output.puts colorise_summary(notification)
    if respond_to?(:dump_commands_to_rerun_failed_examples)
      dump_commands_to_rerun_failed_examples
    end
  end

  # -------
  #

end
