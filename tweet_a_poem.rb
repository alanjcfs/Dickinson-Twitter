#!/usr/bin/env ruby
# coding: utf-8
require_relative 'lib/poem_picker'

poem = PoemPicker.new(ARGV.shift)
poem.display
poem.ask_to_tweet
