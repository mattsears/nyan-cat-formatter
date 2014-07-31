require "rspec/core/formatters/base_text_formatter"
require 'ostruct'

class RSpec3 < RSpec::Core::Formatters::BaseTextFormatter
  include NyanCat::Common

  attr_reader :example_name

  RSpec::Core::Formatters.register self, :example_started, :example_passed, :example_pending,
    :example_failed, :start_dump, :start

  def initialize(output)
    super(output)
    # @failure_count = 0
    # @pending_count = 0
  end

  def start(notification)
    # TODO: Lazy fix for specs.
    if notification.kind_of?(Fixnum)
      super(OpenStruct.new(:count => notification))
    else
      super(notification)
    end

    @current = @color_index = @passing_count = @failure_count = @pending_count = 0
    @example_results = []
    @failed_examples = []
    @pending_examples = []
  end

  def example_started(notification)
    if notification.respond_to?(:example)
      notification = notification.example
    end
    @example_name = notification.full_description
  end

  def example_passed(notification)
    tick PASS
  end

  def example_pending(notification)
    @pending_examples << notification
    @pending_count += 1
    tick PENDING
  end

  def example_failed(notification)
    @failed_examples << notification
    @failure_count += 1
    tick FAIL
  end

  def start_dump(notification)
    @current = @example_count
  end

  def dump_summary(notification)
    duration      = notification.duration
    summary = "\nYou've Nyaned for #{format_duration(duration)}\n".split(//).map { |c| rainbowify(c) }
    output.puts summary.join
    output.puts notification.fully_formatted
    if respond_to?(:dump_commands_to_rerun_failed_examples)
      dump_commands_to_rerun_failed_examples
    end
  end
end
