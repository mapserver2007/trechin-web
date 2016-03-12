require 'bundler/setup'
require 'rack'
require 'sinatra'
$stdout.sync = true if development?
require 'sinatra/reloader' if development?
require 'sinatra/content_for'
require 'yaml'
require 'json'
require File.dirname(__FILE__) + '/bootstrap'
Bootstrap.init :controllers, :models
Model::ModelBase.config = 'config/mlab.test.yml'

run Sinatra::Application
