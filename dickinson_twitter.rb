#!/usr/bin/env ruby
# encoding: UTF-8
require 'twitter'
require './oauth_configure'
# require './generator'
# require './tweet'
ONE_MINUTE = 60

class PoemPicker
  # include PoemTweeter
  def initialize(arg)
    # creates an array of filenames
    @list_of_files = 'marshal'
    @filenames = Marshal.load(File.read(@list_of_files))
    @number = arg
  end

  attr_accessor :number

  def pick
    if @number
      @filenames[@number.to_i]
    else
      @filenames.sample
    end
  end

  def display
    pick unless @number # ensures that recite doesn't call nil on @filenames
    @poem = File.open("./#{ @filenames }", 'r').read
    puts "The poem picked is #{@number.to_i}"
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

class PoemTweeter
  def initialize(poem)
    @lines = poem.split("\n")
    @client = Twitter::Client.new
  end

  def make_stanza lines, stanzas # lines are arrays
    stanzas.push(
      lines.inject do |tweet, line|
        tweet_line = tweet + "\n" + line
        if tweet_line.size > 130
          stanzas.push(tweet)
          line
        else
          tweet_line
        end
      end
      )
    stanzas
    # s<<(l.inject {|c,m|((c+m).size>140)?(s<<c;m):(c+"\n"+m)})
    # stanzas = []
    # if lines.size % 4 == 0
    #   (lines.size / 4).times do |line|
    #     stanzas << lines[line*4...line*4+4].join("\n")
    #   end
    # else (lines.size / 4 + 1).times do |line|
    #     stanzas << lines[line*4...line*4+4].join("\n")
    #   end
    # end
    # return stanzas
  end

  def tweet
    # @lines = poem.split("\n")
    @stanzas = make_stanza(@lines, [])
    @stanzas.each_with_index do |stanza, _|
      @client.update(stanza)
      puts "Successfully tweeted"
      puts stanza
      sleep ONE_MINUTE unless @stanzas[(_+1)].nil?
    end
    # make_stanza.each do |stanza| 
    #   # hack to ensure Dickinson doesn't tweet more than 140 characters.
    #   if stanza.length < 140
    #     @client.update("#{stanza}")
    #     puts "\n\nsuccessfully tweeted"
    #     puts stanza
    #     # take a break before tweeting again
    #     sleep ONE_MINUTE
    #   else
    #     split_stanza = stanza.split("\n")
    #     @client.update("#{split_stanza[0...2].join("\n")}")
    #     sleep ONE_MINUTE
    #     @client.update("#{split_stanza[2...4].join("\n")}")
    #     puts stanza
    #     sleep ONE_MINUTE
    #   end
      # begin
      #   @client.update("#{ stanza }")
      # rescue Twitter::Error::Forbidden => e
      #   puts "Rescued Twitter::Error::Forbiden: #{e}"
      # end
  end
end

poem = PoemPicker.new(ARGV.shift)
poem.display
poem.ask_to_tweet
