# coding: utf-8
class PoemTweeter
  def initialize(poem)
    @lines = poem.split("\n")
    @client = Twitter::Client.new
  end

  def make_stanza lines, stanzas # lines are arrays
    stanzas.push(
      lines.inject do |tweet, line|
        tweet_line = tweet + "\n" + line
        if tweet_line.size >= 130
          stanzas.push(tweet)
          line
        else
          tweet_line
        end
      end
      )
    stanzas
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
      # begin
      #   @client.update("#{ stanza }")
      # rescue Twitter::Error::Forbidden => e
      #   puts "Rescued Twitter::Error::Forbiden: #{e}"
      # end
  end
end
