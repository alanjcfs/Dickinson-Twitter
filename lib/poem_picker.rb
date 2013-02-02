# encoding: UTF-8
require 'twitter'
require 'securerandom'
require_relative '../oauth_configure'
require_relative 'poem_tweeter'
ONE_MINUTE = 60

class PoemPicker
  # include PoemTweeter
  def initialize(arg)
    # creates an array of filenames
    @list_of_files = 'marshal'
    @filenames = Marshal.load(File.read(@list_of_files))
    @arg = arg
  end

  attr_reader :number, :poem

  def pick(arg=@arg)
    poem =
    if arg.nil?
      size = @filenames.size
      @filenames[SecureRandom.random_number(size)]
    else
      @filenames[arg]
    end
    @poem = File.open("./#{ poem }", 'r').read
  end

  def display
    pick(@arg)
    puts "The poem picked is this: "
    puts @poem
    puts
  end

  def ask_to_tweet
    begin
      puts "Do you want to tweet this poem? (Y/n/quit)"
      input = gets.chomp.upcase
      if input == "NO" or input == "N" then
        pick
        display
      end
    end until (input == "QUIT" or input == "Y" or input == "YES" or input.empty?)

    if input == "QUIT"
      Process.exit 0
    else
      PoemTweeter.new(@poem).tweet
    end
  end
end




