require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

before do
  @contents = File.readlines("data/toc.txt")
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  # @contents = File.readlines("data/toc.txt")

  erb :home
end

# get "/chapters/1" do
#   @title = "Chapter 1"
#   @contents = File.readlines("data/toc.txt")
#   @chapter = File.read("data/chp1.txt")

#   erb :chapter
# end

get "/chapters/:number" do
  # @contents = File.readlines("data/toc.txt")

  number = params[:number].to_i
  chapter_name = @contents[number - 1]

  redirect "/" unless (1..@contents.size).cover? number

  @title = "Chapter #{number}: #{chapter_name}"

  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end

get "/show/:name" do
  params[:name]
end

# Calls the block for each chapter, passing that chapter's number, name, and
# contents.
def each_chapter
  @contents.each_with_index do |name, index|
    number = index + 1
    contents = File.read("data/chp#{number}.txt")
    yield number, name, contents
  end
end

# # This method returns an Array of Hashes representing chapters that match the
# # specified query. Each Hash contain values for its :name and :number keys.
# def chapters_matching(query)
#   results = []

#   return results if !query || query.empty?

#   each_chapter do |number, name, contents|
#     results << {number: number, name: name} if contents.include?(query)
#   end

#   results
# end

# This method returns an Array of Hashes representing chapters that match the
# specified query. Each Hash contain values for its :name, :number, and
# :paragraphs keys. The value for :paragraphs will be a hash of paragraph indexes
# and that paragraph's text.
def chapters_matching(query)
  results = []

  return results unless query

  each_chapter do |number, name, contents|
    matches = {}
    contents.split("\n\n").each_with_index do |paragraph, index|
      matches[index] = paragraph if paragraph.include?(query)
    end
    results << {number: number, name: name, paragraphs: matches} if matches.any?
  end

  results
end

get "/search" do
  @results = chapters_matching(params[:query])
  erb :search
end

# get "/" do
#   File.read "public/template.html"
# end

# get "/" do
#   "Hello World!"
# end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").each_with_index.map do |line, index|
      "<p id=paragraph#{index}>#{line}</p>"
    end.join
  end

  def highlight(text, term)
    text.gsub(term, %(<strong>#{term}</strong>))
  end
end

not_found do
  redirect "/"
end
