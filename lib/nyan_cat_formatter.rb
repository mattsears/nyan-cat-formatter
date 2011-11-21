# -*- coding: utf-8 -*-
require 'rspec/core/formatters/base_text_formatter'

class NyanCatFormatter < RSpec::Core::Formatters::BaseTextFormatter

  ESC      = "\e["
  NND      = "#{ESC}0m"
  PASS     = '='
  PASS_ARY = ['-', '_']
  FAIL     = '*'
  ERROR    = '!'
  PENDING  = '+'

  attr_reader :current, :example_results, :color_index

  def start(example_count)
    super(example_count)
    @current, @color_index, @passing_count = 0,0,0
    @example_results = []
  end

  def example_passed(example)
    super(example)
    tick PASS
  end

  def example_pending(example)
    super(example)
    @pending_count =+1
    tick PENDING
  end

  def example_failed(example)
    super(example)
    @failure_count =+1
    tick FAIL
  end

  def start_dump
    @current = @example_count
  end

  def dump_summary(duration, example_count, failure_count, pending_count)
    dump_profile if profile_examples? && failure_count == 0
    summary = "\nNyan Cat flew #{format_seconds(duration)} seconds".split(//).map { |c| rainbowify(c) }
    output.puts summary.join
    output.puts colorise_summary(summary_line(example_count, failure_count, pending_count))
    dump_commands_to_rerun_failed_examples
  end

  def dump_failures
    #no op
  end

  # Increments the example count and displays the current progress
  #
  # @returns nothing
  def tick(mark = PASS)
    @example_results << mark
    @current =  (@current > @example_count) ? @example_count : @current + 1
    dump_progress
  end

  # Creates a rainbow trail
  #
  # @return [String] the sprintf format of the Nyan cat
  def nyan_trail
    marks = @example_results.map{ |mark| highlight(mark) }
    marks.shift(current_width - terminal_width) if current_width > terminal_width
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
    if @failure_count > 0 || @pending_count > 0
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
    padding = @example_count.to_s.length * 2 + 2
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
    padding = @example_count.to_s.length + 9
    [ @current.to_s.rjust( @example_count.to_s.length),
      green(@current - @pending_examples.size - @failed_examples.size).rjust(padding),
      yellow(@pending_examples.size).rjust(padding),
      red(@failed_examples.size).rjust(padding) ]
  end

  # Ascii version of Nyan cat. Two cats in the array allow Nyan to animate running.
  #
  # @param o [String] Nyan's eye
  # @return [Array] Nyan cats
  def ascii_cat(o = '^')
    [[ "_,------,   ",
        "_|  /\\_/\\ ",
        "~|_( #{o} .#{o})  ",
        " \"\"  \"\" "
      ],
      [ "_,------,   ",
        "_|   /\\_/\\",
        "^|__( #{o} .#{o}) ",
        "  \"\"  \"\"    "
      ]]
  end

  # Colorizes the string with raindow colors of the rainbow
  #
  # @params string [String]
  # @return [String]
  def rainbowify(string)
    c = colors[@color_index % colors.size]
    @color_index += 1
    "#{ESC}38;5;#{c}m#{string}#{NND}"
  end

  # Calculates the colors of the rainbow
  #
  # @return [Array]
  def colors
    @colors ||= (0...(6 * 7)).map do |n|
      pi_3 = Math::PI / 3
      n *= 1.0 / 6
      r  = (3 * Math.sin(n           ) + 3).to_i
      g  = (3 * Math.sin(n + 2 * pi_3) + 3).to_i
      b  = (3 * Math.sin(n + 4 * pi_3) + 3).to_i
      36 * r + 6 * g + b + 16
    end
  end

  # Determines how to color the example.  If pass, it is rainbowified, otherwise
  # we assign red if failed or yellow if an error occurred.
  #
  # @return [String]
  def highlight(mark = PASS)
    case mark
    when PASS;  rainbowify PASS_ARY[@color_index%2]
    when FAIL;  red mark
    when ERROR; yellow mark
    else mark
    end
  end

end

