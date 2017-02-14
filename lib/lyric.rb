# frozen_string_literal: true
require 'faraday'
require 'nokogiri'
require 'uri'

class Lyric
  attr_reader *%i(text thumbnail_url embed_movie_src)

  def initialize(url)
    @uri = URI.parse(url)
    @doc = parsed_document
    @text = lyric_text
    @thumbnail_url = amazon_thumbnail
    @embed_movie_src = youtube_embed_src
  end

  private

  def parsed_document
    connection = ::Faraday.new(url: @uri.scheme + '://' + @uri.host)
    response = connection.get @uri.path

    ::Nokogiri::HTML(response.body)
  end

  def lyric_text
    @doc.xpath("//div[@class='kashitext']")
        .css('p')
        .map(&:inner_text)
        .join("\n\n")
  end

  def amazon_thumbnail
    img_element = @doc.xpath("//div[@class='amazoncd']/a/img")
    return if img_element.empty?

    img_element.attribute('src').value
  end

  def youtube_embed_src
    embed_element = @doc.xpath("//iframe[@class='js-tubepress-embed']")
    return if embed_element.empty?

    embed_element.attribute('src').value
  end
end
