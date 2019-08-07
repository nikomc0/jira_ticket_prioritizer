require 'dotenv'
require 'pp'
require 'jira-ruby'
require 'sinatra'

Dotenv.load('.env')

class ApplicationController < Sinatra::Base
	configure do
  	set :views, "src/views"
  	set :public_dir, "public"
  end
end