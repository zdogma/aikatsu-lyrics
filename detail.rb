# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('lib', File.dirname(__FILE__))

require 'lyric'
require 'csv'

CSV_INPUT_PATH = 'db/masters/aikatsu_index.csv'
CSV_OUTPUT_PATH = 'tmp/aikatsu_songs.csv'

AikatsuSong = Struct.new(
  *%i(
    series
    scene
    lyric_url
    title
    singer
  )
)

rows = CSV.read(CSV_INPUT_PATH, headers: false)
rows.shift
aikatsu_songs = rows.map { |row| AikatsuSong.new(*row) }

aikatsus = aikatsu_songs.map do |song|
  sleep 0.5 # for scrape interval
  lyric = Lyric.new(song.lyric_url)

  {
    song: song,
    lyric: lyric
  }
end

CSV.open(CSV_OUTPUT_PATH, 'w') do |csv|
  aikatsus.each do |aikatsu|
    new_row = [
      aikatsu[:song].series,
      aikatsu[:song].scene,
      aikatsu[:song].title,
      aikatsu[:song].singer,
      aikatsu[:lyric].text,
      aikatsu[:lyric].thumbnail_url,
      aikatsu[:lyric].embed_movie_src
    ]

    csv << new_row
  end
end
