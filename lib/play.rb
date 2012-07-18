# -*- coding: utf-8 -*-
require 'nyan_cat_formatter'

Play = Class.new(NyanCatFormatter) do
    def self.local_file_exists?
      File.exists?(".nyan-cat.mp3")
    end

    def self.osx?
      RUBY_PLATFORM.downcase.include?("darwin")
    end
  system("afplay .nyan-cat.mp3 &") if local_file_exists? && osx?
end