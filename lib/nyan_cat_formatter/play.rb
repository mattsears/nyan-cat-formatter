# -*- coding: utf-8 -*-
require 'nyan_cat_formatter'
require 'rubygems'

Play = Class.new(NyanCatFormatter) do
  def self.mp3_exists?
    File.exists?(File.expand_path("~/.nyan-cat.mp3"))
  end

  def self.osx?
    RUBY_PLATFORM.downcase.include?("darwin")
  end

  if mp3_exists? && osx?
    system("afplay #{File.expand_path('~/.nyan-cat.mp3')} &")
  elsif osx?
    puts "\n#{File.expand_path('~')}/.nyan-cat.mp3 wasn't found.\nPlease copy .nyan-cat.mp3 to #{File.expand_path('~')}/\n\n"
  end
end
