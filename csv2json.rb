# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('lib', File.dirname(__FILE__))

require 'csv'
require 'json'

CSV_INPUT_PATH = 'tmp/aikatsu_songs.csv'

Song = Struct.new(
  *%i(
    series
    scene
    title
    singer
    text
    thumbnail_url
    embed_movie_src
  )
)

rows = CSV.read(CSV_INPUT_PATH)
songs = rows.map { |row| Song.new(*row) }

print songs.map {|song|
  {
    series: song.series,
    scene: song.scene,
    title: song.title,
    singer: song.singer,
    text: song.text,
    thumbnail_url: song.thumbnail_url.to_s,
    embed_movie_src: song.embed_movie_src.to_s
  }
}.to_json
