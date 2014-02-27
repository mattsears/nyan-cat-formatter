# -*- coding: utf-8 -*-
require 'nyan_cat_formatter'
require 'nyan_cat_format/verbose'

NyanCatVerboseFormatter = Class.new(NyanCatFormatter) do
  include NyanCatFormat::Verbose
end
