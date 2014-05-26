class RSpec2 < RSpec::Core::Formatters::BaseTextFormatter
  include NyanCat::Common

  attr_reader :example_name

  def start(example_count)
    super(example_count)
    @current = @color_index = @passing_count = 0
    @example_results = []
  end

  def example_started(example)
    super(example)
    @example_name = example.full_description
  end

  def example_passed(example)
    super(example)
    tick PASS
  end

  def example_pending(example)
    super(example)
    @pending_count +=1
    tick PENDING
  end

  def example_failed(example)
    super(example)
    @failure_count +=1
    tick FAIL
  end

  def start_dump
    @current = @example_count
  end

  def dump_summary(duration, example_count, failure_count, pending_count)
    dump_profile if profile_examples? && failure_count == 0
    summary = "\nYou've Nyaned for #{format_duration(duration)}\n".split(//).map { |c| rainbowify(c) }
    output.puts summary.join
    output.puts colorise_summary(summary_line(example_count, failure_count, pending_count))
    if respond_to?(:dump_commands_to_rerun_failed_examples)
      dump_commands_to_rerun_failed_examples
    end
  end
end
