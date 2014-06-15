module NyanCatFormat
  module Music

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
      File.expand_path('../../../data/nyan-cat.mp3', __FILE__)
    end

    def start input
      super
      @music_thread = Thread.new { start_music_or_kill(Thread.current) }
      wait_for_music_to_start(@music_thread)
    end

    def dump_summary(*args)
      kill_music
      super
    end

    private

    def kill_music
      if @music_thread && @music_thread['music_pid']
        @music_thread.kill
        Process.kill('KILL', @music_thread['music_pid'])
      end
    end

    def linux_player
      %w{mpg321 mpg123}.find {|player|
        kernel.system("which #{ player } &>/dev/null && type #{ player } &>/dev/null")
      }
    end

    def music_command
      # this isn't really threadsafe but it'll work if we're careful
      return @music_command if @music_command
      if osx?
        @music_command = "afplay #{nyan_mp3}"
      elsif linux? && linux_player
        @music_command = "#{ linux_player } #{ nyan_mp3 } &>/dev/null"
      end
    end

    def start_music_or_kill(thread)
      thread.exit unless File.exists?(nyan_mp3) && music_command
      loop do
        thread['music_pid'] = kernel.spawn(music_command)
        thread["started_playing"] ||= true
        Process.wait(thread['music_pid'])
      end
    end

    def wait_for_music_to_start(music_thread)
      while !music_thread["started_playing"] && music_thread.status
        sleep 0.001
      end
    end
  end
end
