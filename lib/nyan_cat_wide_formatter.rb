# -*- coding: utf-8 -*-
require 'nyan_cat_formatter'
require 'nyan_cat_format/wide'

NyanCatWideFormatter = Class.new(NyanCatFormatter) do
  include NyanCatFormat::Wide
end
