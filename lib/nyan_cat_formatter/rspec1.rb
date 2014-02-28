class RSpec1 < Spec::Runner::Formatter::BaseTextFormatter
  include NyanCat::Common

  def start(example_count)
    super(example_count)
    @example_count = example_count
    @current = @color_index = @passing_count = @failure_count = @pending_count = 0
    @example_results = []
  end

  def example_passed(example)
    super
    @passing_count += 1
    tick PASS
  end

  def example_pending(example, message = nil)
    super
    @pending_count =+1
    tick PENDING
  end

  def example_failed(example, counter = nil, failure = nil)
    super
    @failure_count =+1
    tick FAIL
  end

  def start_dump
    @current = @example_count
  end

  def dump_pending
    output.puts "\e[0;33m"
    super
  end

  def dump_failure(*args)
    output.puts "\e[0;31m"
    super
  end

  def dump_summary(duration, example_count, failure_count, pending_count)
    @output.puts "\nYou've Nyaned for #{format_duration(duration)}\n".each_char.map {|c| rainbowify(c)}.join
    summary = "#{example_count} example#{'s' unless example_count == 1}, #{failure_count} failure#{'s' unless failure_count == 1}"
    summary << ", #{pending_count} pending" if pending_count > 0

    if failure_count == 0
      @output.puts failure_color(summary)
    elsif pending_count > 0
      @output.puts pending_color(summary)
    else
      @output.puts success_color(summary)
    end
    @output.flush
  end
end
