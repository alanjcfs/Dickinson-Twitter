# encoding: UTF-8
require 'rubygems'
require 'twitter'
require './oauth_configure'
require './generator'
require './tweet'
ONE_MINUTE = 60

poem = PoemGenerator.new


# Show user the lines and ask whether to tweet or quit
begin
  input ||= nil
  if input.nil?
    lines = poem.recite # lines will be of Array class
  else
    poem.pick
    lines = poem.recite
  end
  puts "Poem picked: #{poem.picked}"
  puts lines
  print "Approved? (Y/n/quit) "
  input = gets.chomp.upcase
end until (input == "QUIT" or input == "Y" or input == "YES" or input.empty?)

if input == "QUIT"
  Process.exit 0
end

client = Twitter::Client.new
if input == "Y" or input == "YES" or input.empty?
  make_stanza(lines).each do |stanza| 
    # hack to ensure Dickinson doesn't tweet more than 140 characters.
    if stanza.length < 140
      tweet stanza, client
      puts "\n\nsuccessfully tweeted"
      puts stanza
      # take a break before tweeting again
      sleep ONE_MINUTE
    else
      split_stanza = stanza.split("\n")
      tweet split_stanza[0...2].join("\n"), client
      sleep ONE_MINUTE
      tweet split_stanza[2...4].join("\n"), client
      puts stanza
      sleep ONE_MINUTE
    end
  end
end
