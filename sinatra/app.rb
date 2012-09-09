#!/usr/bin/env ruby

require 'sinatra'
require 'slim'
require 'fileutils'

get '/' do
  slim :index
end

post '/' do
  puts params[:root]
  @audios = get_audio_files(params[:root])
  puts @audios.to_s

  slim :index
end

def get_audio_files(path)
  root_sym = './public/root_sym'
  File.delete root_sym
  File.symlink(path, root_sym)

  Dir["#{root_sym}**{,/*/**}/*.{ogg,mp3}"].collect do |f|
    Audio.new(f)
  end
end

class Audio
  attr_accessor :title, :path, :original_path

  def initialize(original_path)
    @title, @original_path = File.basename(original_path), original_path
    @path = "root_sym/#{@title}"
  end
end
