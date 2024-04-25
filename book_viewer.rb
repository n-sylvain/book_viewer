require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @contents = File.readlines("data/toc.txt")
  @chapter = File.read("data/chp1.txt")

  erb :home
end

# get "/" do
#   File.read "public/template.html"
# end

# get "/" do
#   "Hello World!"
# end
