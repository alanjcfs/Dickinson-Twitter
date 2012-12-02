# encoding: UTF-8
require 'multi_json'

class PoemGenerator
  def initialize(arg)
    # creates an array of filenames
    @list_of_files = 'filenames.json'
    @filenames = MultiJson.load(File.open(@list_of_files).read)
    @picked = arg
  end

  attr_accessor :picked

  def pick
    @picked ||= rand(@filenames.size)
  end

  def recite
    pick # ensures that recite doesn't call nil on @filenames
    File.open("./#{ @filenames[@picked.to_i] }", 'r').read.split("\n").reject(&:empty?)
  end
end

    # Find line containing poem number
    # Collect each line until the next number, dividing into four
    # If four_lines.char_count > 140 characters, split at a line