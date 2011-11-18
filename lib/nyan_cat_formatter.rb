# -*- coding: utf-8 -*-
require 'rspec/core/formatters/base_text_formatter'

class NyanCatFormatter < RSpec::Core::Formatters::BaseTextFormatter

  ESC     = "\e["
  NND     = "#{ESC}0m"
  PASS    = '='
  FAIL    = '*'
  ERROR   = '!'
  PENDING = '·'

  attr_reader :title, :current, :example_results, :color_index

  def start(example_count)
    super(example_count)
    @current, @color_index = 0,0
    @bar_length = 70
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
    # noop
  end

  # Increments the example count and displays the current progress
  #
  # Returns nothing
  def tick(mark = PASS)
    @example_results << mark
    @current =  (@current > @example_count) ? @example_count : @current + 1
    @title = "  #{current}/#{example_count}"
    dump_progress
  end

  # Creates a rainbow trail
  #
  # Returns the sprintf format of the Nyan cat
  def nyan_trail
    width =  percentage * @bar_length / 100
    marker = @example_results.map{ |mark| highlight(mark) }.join
    sprintf("%s#{nyan_cat}%s", marker, " " * (@bar_length - width) )
  end

  # Calculates the percentage completed any given point
  #
  # Returns Fixnum of the percentage
  def percentage
    @example_count.zero? ? 100 : @current * 100 / @example_count
  end

  # Ascii Nyan Cat. If tests are complete, Nyan Cat goes to sleep. If
  # there are failing or pending examples, Nyan Cat is concerned.
  #
  # Returns String Nyan Cat
  def nyan_cat
    if @failure_count > 0 || @pending_count > 0
      '~|_(o.o)'
    elsif (@current == @example_count)
      '~|_(-.-)'
    else
      '~|_(^.^)'
    end
  end

  # Displays the current progress in all Nyan Cat glory
  #
  def dump_progress
    title_width = @example_count.to_s.length * 2 + 4
    max_width   = 80
    line  = sprintf("%#{title_width}s %s", @title + ":", nyan_trail)
    tail  = (@current == @example_count) ? "\n" : "\r"

    if line.length == max_width - 1
      output.print line + tail
      output.flush
    elsif line.length >= max_width
      @bar_length = [@bar_length - (line.length - max_width + 1), 0].max
      @bar_length == 0 ? output.print( rainbowify(line + tail) ) : dump_progress
    else
      @bar_length += max_width - line.length + 1
      dump_progress
    end
  end

  # Colorizes the string with raindow colors of the rainbow
  #
  def rainbowify(string)
    c = colors[@color_index % colors.size]
    @color_index += 1
    "#{ESC}38;5;#{c}m#{string}#{NND}"
  end

  # Calculates the colors of the rainbow
  #
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
  def highlight(mark = PASS)
    case mark
      when PASS;  rainbowify mark
      when FAIL;  red mark
      when ERROR; yellow mark
      else mark
    end
  end

end

