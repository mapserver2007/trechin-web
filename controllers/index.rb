require 'cgi'
require 'sinatra/json'

get '/search/:name' do
  json(Train.search(params['name']))
end

get '/commute' do
  json(Train.commute)
end

not_found do
  json({})
end
