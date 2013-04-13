module NyanCatFormat
  module Wide
  
    def example_width(example = current)
      net_width_for(example) - net_width_for(example - 1)
    end

    def net_width_for(example)
      @net_width ||= {}

      @net_width[example] ||= begin
        return 0 if example < 0
        net_width = terminal_width - padding_width - cat_length
        rough_example_width = (net_width * example.to_f / @example_count.to_f)
        rough_example_width.round
      end
    end
    
  end
end
