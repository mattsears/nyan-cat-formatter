module RSpec1
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

  def example_pending(example, message)
    super
    @pending_count =+1
    tick PENDING
  end

  def example_failed(example, counter, failure)
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
    # dump_profile if profile_examples? && failure_count == 0
    @output.puts "\nNyan Cat flew #{duration} seconds\n".each_char.map {|c| rainbowify(c)}.join
    summary = "#{example_count} example#{'s' unless example_count == 1}, #{failure_count} failure#{'s' unless failure_count == 1}"
    summary << ", #{pending_count} pending" if pending_count > 0  

    if failure_count == 0
      if pending_count > 0
        @output.puts yellow(summary)
      else
        @output.puts green(summary)
      end
    else
      @output.puts red(summary)
    end
    @output.flush
  end

  def dump_failures
    #no op
  end

  # Increments the example count and displays the current progress
  #
  # @returns nothing
  def tick(mark = PASS)
    @example_results << mark
    @current = (@current > @example_count) ? @example_count : @current + 1
    dump_progress
  end

  # Creates a rainbow trail
  #
  # @return [String] the sprintf format of the Nyan cat
  def nyan_trail
    marks = @example_results.map{ |mark| highlight(mark) }
    marks.shift(current_width - terminal_width) if current_width >= terminal_width
    nyan_cat_lines = nyan_cat.split("\n").each_with_index.map do |line, index|
      format("%s#{line}", marks.join)
    end.join("\n")
  end

  # Determine which Ascii Nyan Cat to display. If tests are complete,
  # Nyan Cat goes to sleep. If there are failing or pending examples,
  # Nyan Cat is concerned.
  #
  # @return [String] Nyan Cat
  def nyan_cat
    if @failure_count.to_i > 0 || @pending_count.to_i > 0
      ascii_cat('o')[@color_index%2].join("\n") #'~|_(o.o)'
    elsif (@current == @example_count)
      ascii_cat('-')[@color_index%2].join("\n") # '~|_(-.-)'
    else
      ascii_cat('^')[@color_index%2].join("\n") # '~|_(^.^)'
    end
  end

  # Displays the current progress in all Nyan Cat glory
  #
  # @return nothing
  def dump_progress
    line = nyan_trail.split("\n").each_with_index.inject([]) do |result, (trail, index)|
      value = "#{scoreboard[index]}/#{@example_count}:"
      result << format("%s %s", value, trail)
    end.join("\n")
    output.print line + eol
  end

  # Determines how we end the trail line. If complete, return a newline etc.
  #
  # @return [String]
  def eol
    return "\n" if @current == @example_count
    length = (nyan_cat.split("\n").length - 1)
    length > 0 ? format("\e[1A" * length + "\r") : "\r"
  end

  # Calculates the current flight length
  #
  # @return [Fixnum]
  def current_width
    padding    = @example_count.to_s.length * 2 + 6
    cat_length = nyan_cat.split("\n").group_by(&:size).max.first
    padding    + @current + cat_length
  end

  # A Unix trick using stty to get the console columns
  # does not work in JRuby :-(
  #
  # @return [Fixnum]
  def terminal_width
    @terminal_width ||= `stty size`.split.map { |x| x.to_i }.reverse.first - 1
  end

  # Creates a data store of pass, failed, and pending example results
  # We have to pad the results here because sprintf can't properly pad color
  #
  # @return [Array]
  def scoreboard
    @pending_examples ||= []
    @failed_examples ||= []
    padding = @example_count.to_s.length
    [ @current.to_s.rjust(padding),
      green((@current - @pending_examples.size - @failed_examples.size).to_s.rjust(padding)),
      yellow(@pending_count.to_s.rjust(padding)),
      red(@failure_count.to_s.rjust(padding)) ]
  end
end
