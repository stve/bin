#!/usr/bin/env ruby

ENV['BUNDLE_GEMFILE'] = File.join(File.dirname(__FILE__), 'Gemfile')

require 'rubygems'
require 'bundler/setup'

require 'fileutils'
require 'taglib'

DEFAULT_GENRE = 'untagged'

puts 'Detecting MP3 files...'
Dir.glob('*.mp3') do |file|
  filename = File.basename(file, '.mp3')
  parts = filename.split('-')
  artist = parts.shift
  song = parts.join(' - ')

  puts "Song: #{song.strip} by #{artist.strip}"

  # puts 'Updating ID3 tags ...'
  TagLib::FileRef.open(file) do |f|
    unless f.null?
      f.tag.artist  = artist.strip
      f.tag.title   = song.strip
      f.tag.genre   ||= DEFAULT_GENRE

      # update tags
      f.save
    end
  end

  puts '*' * 20
end

