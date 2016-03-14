require 'cgi'
require 'sinatra/json'

get '/search/:name' do
  json(Train.search(params['name']))
end

not_found do
  json({})
end
