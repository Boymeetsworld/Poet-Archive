require 'sinatra'
require "sinatra/reloader"
require 'httparty'
require 'json'
require 'uri'

set :public_folder, File.dirname(__FILE__) + '/public'


POETRYDB_API_BASE_URL = 'https://poetrydb.org'

get '/' do
  erb :index
end

get '/search' do
  
  author = params[:author]
  title = ERB::Util.url_encode params[:title]
  response = HTTParty.get("#{POETRYDB_API_BASE_URL}/author,title/#{author};#{title}")
  pp "#{POETRYDB_API_BASE_URL}/author,title/#{author};#{title}"
  pp response.body 
  if response.success?
    begin
      @poems = JSON.parse(response.body)
      if @poems.empty?
        redirect to('/')
      end
    rescue JSON::ParserError => e
      puts "Error parsing JSON response: #{e.message}"
      redirect to('/')
    end
    erb :poems
  else
    redirect to('/')
  end
end
