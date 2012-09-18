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
    play_on_linux if linux?
  end

  def kill_music
    if File.exists? nyan_mp3
      system("killall -9 afplay &>/dev/null") if osx?
      kill_music_in_linux if linux?
    end
  end

  private
    
  def play_on_linux
    kernel.system("[ -e #{nyan_mp3} ] && type mpg321 &>/dev/null && mpg321 #{nyan_mp3} &>/dev/null &") if kernel.system('which mpg321 && type mpg321')
    kernel.system("[ -e #{nyan_mp3} ] && type mpg123 &>/dev/null && mpg123 #{nyan_mp3} &>/dev/null &") if kernel.system('which mpg123 && type mpg123')
  end

  def kill_music_on_linux 
    system("killall -9 mpg321 &>/dev/null") if kernel.system("which mpg321 && type mpg321")
    system("killall -9 mpg123 &>/dev/null") if kernel.system("which mpg123 && type mpg123")
  end

end
