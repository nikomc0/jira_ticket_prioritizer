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

	@esups = []

	def self.get_issues
		esups = []
			loop do 
				issues = @@client.Issue.jql(
					'PROJECT = "Escalations Support" AND ISSUETYPE in ("Bug", "Task")
					AND CREATOR in ("klange", "ddelbosque", "balbini", "jluse", "apaley")',
					max_results: 100, start_at: esups.size)
				esups.push(*issues)
			break if issues.size == 0
			end

		@esups = esups
	end

	IssueController.get_issues

	@@prioritizer = TicketPrioritizer::Prioritizer.new(@esups)

	def priority_tickets
		@@prioritizer.get_array
	end

	get '/' do
		@user = @@client.options[:username]
		erb :index
	end
end
