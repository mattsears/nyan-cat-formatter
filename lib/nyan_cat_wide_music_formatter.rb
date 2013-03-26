# -*- coding: utf-8 -*-
require 'nyan_cat_formatter'
require 'nyan_cat_format/wide'
require 'nyan_cat_format/music'

NyanCatWideMusicFormatter = Class.new(NyanCatFormatter) do
  include NyanCatFormat::Wide
  include NyanCatFormat::Music
end
