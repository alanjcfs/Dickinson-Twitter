# encoding: UTF-8
require 'rubygems'
require 'twitter'
require './oauth_configure'
require './generator'
SLEEP_TIME = 300

# poem = PoemGenerator.new.recite.split("\n").reject(&:empty?)

poem = PoemGenerator.new
lines = poem.recite

def tweet(lines, stanza=4, picked)
  client = Twitter::Client.new

  puts "Poem picked: #{ picked }"

  (lines.size / stanza).times do |num|
    begin
      stanza = lines[num*4...num*4+4].join("\n")
      if stanza.size <= 140
        puts "Tweeting:\n#{ stanza }"
        client.update("#{ stanza }")
      else
        stanza_1 = lines[num*4...num*4+2].join("\n")
        stanza_2 = lines[num*4+2...num*4+4].join("\n")
        puts "Tweeting:\n#{ stanza_1 }"
        client.update("#{ stanza_1 }")

        randomized_time = SLEEP_TIME - rand(60...SLEEP_TIME)
        puts "Sleeping #{ randomized_time } seconds between broken stanza!"
        sleep randomized_time
        
        puts "Tweeting:\n#{ stanza_2 }"
        client.update("#{ stanza_2 }")
      end
    rescue Twitter::Error::Forbidden => e
      puts "Rescued Twitter::Error:Forbidden: #{e}"
    else
      puts "all went well!"
    ensure
      randomized_time = SLEEP_TIME + rand(SLEEP_TIME)
      puts "\nSleep for #{ randomized_time } seconds!\n"
      sleep randomized_time
    end
  end

  Twitter.reset
end

class EmptyStatusError < StandardError
end

if lines.size % 4 == 0
  tweet(lines, lines.size / 4, poem.picked)
else tweet(lines, lines.size / 4 + 1, poem.picked)
end 