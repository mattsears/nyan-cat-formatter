# -*- coding: utf-8 -*-
require 'nyan_cat_formatter'

NyanCatMusicFormatter = Class.new(NyanCatFormatter) do
  def osx?
    platform.downcase.include?("darwin")
  end

  def linux?
    platform.downcase.include?('linux')
  end

  def kernel=(kernel)
    @kernel = kernel
  end

  def kernel
    @kernel ||= Kernel
  end

  def platform=(platform)
    @platform = platform
  end

  def platform
    @platform ||= RUBY_PLATFORM
  end

  def nyan_mp3
    File.expand_path('../../data/nyan-cat.mp3', __FILE__)
  end

  def start input
    super
    kernel.system("afplay #{nyan_mp3} &") if osx?
    kernel.system("[ -e #{nyan_mp3} ] && type mpg321 &>/dev/null && mpg321 #{nyan_mp3} &>/dev/null &") if linux?
  end

  def kill_music
    if File.exists? nyan_mp3
      system("killall -9 afplay &>/dev/null") if osx?
      system("killall -9 mpg321 &>/dev/null") if linux?
    end
  end
end
