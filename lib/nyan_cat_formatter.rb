# -*- coding: utf-8 -*-

rspec_bin = $0.split('/').last
if rspec_bin == 'rspec'
  ['rspec2','rspec/core/formatters/base_text_formatter'].each {|f| require f}
  parent_class = RSpec::Core::Formatters::BaseTextFormatter
  nyan_module = RSpec2
elsif rspec_bin == 'spec'
  ['spec', 'rspec1', 'spec/runner/formatter/base_text_formatter'].each {|f| require f}
  parent_class = Spec::Runner::Formatter::BaseTextFormatter
  nyan_module = RSpec1
end


NyanCatFormatter = Class.new(parent_class) do

  ESC      = "\e["
  NND      = "#{ESC}0m"
  PASS     = '='
  PASS_ARY = ['-', '_']
  FAIL     = '*'
  ERROR    = '!'
  PENDING  = '+'

  include nyan_module

  attr_reader :current, :example_results, :color_index

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
    when PASS; rainbowify PASS_ARY[@color_index%2]
    when FAIL; "\e[31m#{mark}\e[0m"
    when ERROR; "\e[33m#{mark}\e[0m"
    when PENDING; "\e[33m#{mark}\e[0m"
    else mark
    end
  end

end

