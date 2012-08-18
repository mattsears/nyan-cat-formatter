# -*- coding: utf-8 -*-
require 'nyan_cat_formatter'

NyanCatMusicFormatter = Class.new(NyanCatFormatter) do
  def osx?
    platform.include?("darwin")
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

  def start input
    super
    kernel.system("afplay #{File.expand_path('../../data/nyan-cat.mp3', __FILE__)} &") if osx?
  end
end
