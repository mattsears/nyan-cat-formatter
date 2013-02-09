# -*- coding: utf-8 -*-
require 'nyan_cat_formatter'

NyanCatWideFormatter = Class.new(NyanCatFormatter) do
  def example_width(item = current)
    net_width_for(item) - net_width_for(item - 1)
  end

  def net_width_for(example)
    return 0 if example < 0
    net_width = terminal_width - padding_width - cat_length
    rough_example_width = (net_width * example.to_f / @example_count.to_f)
    rough_example_width.round
  end
end
