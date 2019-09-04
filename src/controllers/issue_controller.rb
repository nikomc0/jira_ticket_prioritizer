require 'dotenv'
require 'pp'
require 'jira-ruby'
require 'sinatra/base'
require_relative '../services/prioritizer'

Dotenv.load('.env')

class IssueController < ApplicationController
	options = {
		:username => ENV['USERNAME'],
		:password => ENV['API_TOKEN'],
		:site     => 'https://YOURCOMPANY.atlassian.net', # or 'https://<your_subdomain>.atlassian.net'
		:context_path => '', # often blank
		:auth_type => :basic,
		:read_timeout => 120
	}

	@@client = JIRA::Client.new(options)

	@data = {
		bugs: @@client.Issue.jql(
			'PROJECT = "Escalations Support" AND ISSUETYPE in ("Bug")
				AND created > -30d
				AND CREATOR in ("USERS")',
				fields:[:status, :summary, :priority, :issuetype, :created, :updated, :lastViewed, :assignee, :creator, :reporter, :duedate, :comment],
				max_results: 100),
		tasks: @@client.Issue.jql(
			'PROJECT = "Escalations Support" AND ISSUETYPE in ("Task")
				AND not status = "closed"
				AND created > -30d
				AND CREATOR in ("USERS")',
				fields:[:status, :summary, :priority, :issuetype, :created, :updated, :lastViewed, :assignee, :creator, :reporter, :duedate, :comment],
				max_results: 100)
	}
	
	# get_issues
	@@bugs = TicketPrioritizer::Bugs.new(@data)
	@@tasks = TicketPrioritizer::Tasks.new(@data)

	# @p3 = @@client.Issue.jql('PROJECT = "Escalations Support" AND ISSUETYPE in ("Bug") AND created > -30d AND PRIORITY in ("Bug - P3 - Medium", "Task - P3 - Medium") AND CREATOR in ("klange", "ddelbosque", "balbini", "jluse", "apaley")', max_results: 100)

	def priority_tickets
		bugs = @@bugs.get_array 
		tasks = @@tasks.get_array
		bugs.concat(tasks)
	end


	get '/' do
		@user = @@client.options[:username]
		@recent = @@client.Issue.jql(
			'PROJECT = "Escalations Support"
				AND ISSUETYPE in ("Bug", "Task")
				AND updatedDate > -12h
				AND NOT status changed AFTER startOfDay()
				AND CREATOR in ("USERS")',
				fields:[:status, :summary, :priority, :issuetype, :created, :updated, :lastViewed, :assignee, :creator, :reporter, :duedate, :comment],
				max_results: 100)
		erb :index
	end

	get '/p3' do
		@data
		pp @data
		erb :'/p3'
	end

	get '/p2' do
		@data
		puts @data
		erb :'/p2'
	end

	get '/p1' do
		@data
		puts @data
		erb :'/p1'
	end

	get '/p0' do
		@data
		puts @data
		erb :'p0'
	end
end
