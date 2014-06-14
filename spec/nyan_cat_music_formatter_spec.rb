require 'spec_helper'
require 'stringio'
require 'fileutils'
require 'nyan_cat_music_formatter'

class MockKernel
  def system(string)
    seen << string
  end

  def spawn(string)
    seen << string
    rand(10000)
  end

  def seen
    @seen ||= []
  end
end

describe NyanCatMusicFormatter do
  let(:path_to_mp3) { NyanCatMusicFormatter.new(NyanCatFormatter).nyan_mp3 }
  let(:stdout)      { StringIO.new }
  let(:formatter)   { described_class.new stdout }
  let(:mock_kernel) { MockKernel.new }

  before { formatter.kernel = mock_kernel }

  describe 'kernel' do
    it 'defaults to Kernel' do
      expect(described_class.new(stdout).kernel).to eq(Kernel)
    end

    it 'can be set' do
      formatter = described_class.new stdout
      formatter.kernel = 'something else'
      expect(formatter.kernel).to eq('something else')
    end
  end

  describe 'platform' do
    it 'defaults to RUBY_PLATFORM' do
      expect(described_class.new(stdout).platform).to eq(RUBY_PLATFORM)
    end

    it 'can be set' do
      formatter = described_class.new stdout
      formatter.platform = 'something else'
      expect(formatter.platform).to eql('something else')
    end
  end

  describe 'start' do
    before do
      allow(Process).to receive(:wait) { sleep 1 }
      allow(Process).to receive(:kill).and_return(true)
    end

    it 'sets the total amount of specs' do
      formatter.start 3
      expect(formatter.example_count).to eql(3)
    end

    it 'sets the current to 0' do
      formatter.start 3
      expect(formatter.current).to eql(0)
    end

    context 'when on OS X' do
      before { formatter.platform = 'darwin' }

      it 'plays the song in the background' do
        formatter.start 3
        expect(mock_kernel.seen).to include("afplay #{path_to_mp3}")
      end
    end

    context 'when on linux' do
      before { formatter.platform = 'linux'}

      it 'plays the song for linux too with mpg123 when available' do
        allow(mock_kernel).to receive(:system).with(match(/which mpg123/)).and_return(true)
        allow(mock_kernel).to receive(:system).with(match(/which mpg321/)).and_return(false)
        formatter.start 10
        expect(mock_kernel.seen.any? { |entry| entry. end_with? "mpg123 #{path_to_mp3} &>/dev/null" }).to be
      end

      it 'plays the song for linux too with mpg321 when available' do
        allow(mock_kernel).to receive(:system).with(match(/which mpg321/)).and_return(true)
        allow(mock_kernel).to receive(:system).with(match(/which mpg123/)).and_return(false)
        formatter.start 10
        expect(mock_kernel.seen.any? { |entry| entry. end_with? "mpg321 #{path_to_mp3} &>/dev/null" }).to be
      end
    end

    context 'when on Windows' do
      before { formatter.platform = 'windows' }

      it 'does not play the song' do
        formatter.start 4
        expect(mock_kernel.seen).to be_empty
      end
    end

    context 'when the music file does not exist' do
      before do
        FileUtils.mv path_to_mp3, "#{ path_to_mp3 }.tmp"
      end

      after do
        FileUtils.mv "#{ path_to_mp3 }.tmp", path_to_mp3
      end

      it "won't try to play anything" do
        formatter.start 42
        expect(mock_kernel.seen).to be_empty
      end
    end
  end
end
