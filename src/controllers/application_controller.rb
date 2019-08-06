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

	options = {
	  :username => ENV['USERNAME'],
	  :password => ENV['API_TOKEN'],
	  :site     => 'https://demandbase.atlassian.net', # or 'https://<your_subdomain>.atlassian.net'
	  :context_path => '', # often blank
	  :auth_type => :basic,
	  :read_timeout => 120
	}

	client = JIRA::Client.new(options)

	esup = client.Issue.jql("PROJECT = 'ESUP'")
	pp esup

	get '/' do
		@esup = client.Issue.jql('PROJECT = "ESUP"')
		erb :index
	end
end