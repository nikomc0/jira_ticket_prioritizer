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
		:site     => 'https://demandbase.atlassian.net', # or 'https://<your_subdomain>.atlassian.net'
		:context_path => '', # often blank
		:auth_type => :basic,
		:read_timeout => 120
	}

	@@client = JIRA::Client.new(options)

	esups = @@client.Issue.jql(
		'PROJECT = "Escalations Support" AND ISSUETYPE in ("Bug", "Task") 
		AND CREATOR in ("klange", "ddelbosque", "balbini", "jluse", "apaley")',
		# fields:[:status, :summary, :priority, :issuetype, :created, :updated, :lastViewed, :assignee, :creator],
		max_results: 1000)

	# pp esups[0..4]

	# fields = @@client.Field.all
	# fields.each do |item|
	# 	pp item.key
	# end

	@@prioritizer = TicketPrioritizer::Prioritizer.new(esups)

	def priority_tickets
		@@prioritizer.get_array
	end

	get '/' do
		# @user = @@client.options[:username]
		erb :index
	end
end
