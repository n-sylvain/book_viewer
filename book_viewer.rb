require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

get "/" do
  erb :home
end

# get "/" do
#   File.read "public/template.html"
# end

# get "/" do
#   "Hello World!"
# end
