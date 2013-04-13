module NyanCatFormat
  module Music
  
    MUSIC_LENGTH = 27.06 # seconds

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
      t = Thread.new do
        loop do
          if osx?
            kernel.system("afplay #{nyan_mp3} &")
          elsif linux?
            play_on_linux
          end
          Thread.current["started_playing"] ||= true
          sleep MUSIC_LENGTH
        end
      end
      until t["started_playing"]
        sleep 0.001
      end
    end

    def kill_music
      if File.exists? nyan_mp3
        if osx?
          system("killall -9 afplay &>/dev/null")
        elsif linux?
          kill_music_on_linux
        end
      end
    end

    def dump_summary(duration, example_count, failure_count, pending_count)
      kill_music
      super
    end
    
    private

    def play_on_linux
      kernel.system("[ -e #{nyan_mp3} ] && type mpg321 &>/dev/null && mpg321 #{nyan_mp3} &>/dev/null &") if kernel.system('which mpg321 &>/dev/null && type mpg321 &>/dev/null')
      kernel.system("[ -e #{nyan_mp3} ] && type mpg123 &>/dev/null && mpg123 #{nyan_mp3} &>/dev/null &") if kernel.system('which mpg123 &>/dev/null && type mpg123 &>/dev/null')
    end

    def kill_music_on_linux
      system("killall -9 mpg321 &>/dev/null") if kernel.system("which mpg321 &>/dev/null && type mpg321 &>/dev/null")
      system("killall -9 mpg123 &>/dev/null") if kernel.system("which mpg123 &>/dev/null && type mpg123 &>/dev/null")
    end

  end
end
