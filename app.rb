require 'sinatra'
require "sinatra/reloader"
require 'httparty'
require 'json'

POETRYDB_API_BASE_URL = 'https://poetrydb.org'

get '/' do
  erb :index
end

get '/search' do
  keyword = params[:keyword]
  response = HTTParty.get("#{POETRYDB_API_BASE_URL}/author/#{keyword}")

  if response.success?
    @poems = JSON.parse(response.body)
    erb :poems
  else
    @error_message = "Error: #{response.code}"
    erb :error
  end
end
