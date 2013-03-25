# -*- coding: utf-8 -*-
require 'nyan_cat_formatter'
require 'nyan_cat_format/music'

NyanCatMusicFormatter = Class.new(NyanCatFormatter) do
  include NyanCatFormat::Music
end
