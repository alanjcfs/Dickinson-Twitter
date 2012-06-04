# encoding: UTF-8
require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/List_of_Emily_Dickinson_poems"))

# Creates a {title => link} hash of all 1,775 poems
# doc.css(".extiw").first.attr("href")
hsh = {}
doc.css('.extiw').each do |element|
  hsh[element.text.gsub(" ", "_")] = element.attr('href')
end

# Obtains the poem
# Nokogiri::HTML(open("http:#{doc.css('.extiw').first.attr('href')}"))
# bee.css(".poem").text

hsh.each do |pair|
  poem = "./poems/#{pair.first}.txt"
  begin
    if File.size(poem) == 0
      lines = Nokogiri::HTML(open("http:#{pair.last}")).css(".poem").text
      File.open(poem, 'w') { |f| f.write(lines) }
    end
  rescue OpenURI::HTTPError
    File.open(poem, 'w')
  end
end

# 1,494 items