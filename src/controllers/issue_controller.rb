require 'dotenv'
require 'pp'
require 'jira-ruby'
require 'sinatra'

Dotenv.load('.env')

class IssueController < Sinatra::Base
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

	@@client = JIRA::Client.new(options)

	@esups = @@client.Issue.jql('PROJECT = "ESUP" AND ISSUETYPE in ("Bug", "Task") AND CREATOR in ("ddelbosque", "balbini", "jluse", "apaley") AND STATUS in ("new", "In Progress", "acknowledge")', fields:[:status, :summary, :priority, :issuetype, :created, :updated, :lastViewed, :assignee, :creator], max_results: 1000)
	# @unassigned = @@client.Issue.jql('PROJECT = "ESUP" AND ISSUETYPE in ("Bug", "Task") AND ASSIGNEE is EMPTY')

	pp @esups[0]
	# pp @unassigned

	def esups
		@esups = @@client.Issue.jql('PROJECT = "ESUP" AND ISSUETYPE in ("Bug", "Task") AND CREATOR in ("klange", "ddelbosque", "balbini", "jluse", "apaley") AND STATUS in ("new", "In Progress", "acknowledge")', fields:[:status, :summary, :priority, :issuetype, :created, :updated, :lastViewed, :assignee, :creator], max_results: 1000)
	end

	def unassigned
		@unassigned = @@client.Issue.jql('PROJECT = "ESUP" AND CREATOR in ("klange", "ddelbosque", "balbini", "jluse", "apaley") AND ISSUETYPE in ("Bug", "Task") AND ASSIGNEE is EMPTY')
	end

	def support_engineer
		@esups = @@client.Issue.jql('PROJECT = "ESUP" AND ISSUETYPE in ("Bug", "Task") AND CREATOR in ("klange") AND STATUS in ("new", "In Progress", "acknowledge")', fields:[:status, :summary, :priority, :issuetype, :created, :updated, :lastViewed, :assignee, :creator, :reporter, :description], max_results: 1000)
	end

	get '/' do
		@user = @@client.options[:username]
		erb :index
	end

	get '/unassigned' do
		erb :unassigned
	end

	get '/kevin' do
		erb :kevin
	end
end
