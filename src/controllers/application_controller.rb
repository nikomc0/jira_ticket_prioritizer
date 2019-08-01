require 'dotenv'
require 'pp'
require 'jira-ruby'
require 'sinatra'

Dotenv.load('.env')

class ApplicationController < Sinatra::Base
	options = {
	  :username => ENV['USERNAME'],
	  :password => ENV['API_TOKEN'],
	  :site     => 'https://supsupport.atlassian.net', # or 'https://<your_subdomain>.atlassian.net'
	  :context_path => '', # often blank
	  :auth_type => :basic,
	  :read_timeout => 120
	}

	client = JIRA::Client.new(options)

	# List All Projects
	# projects = client.Project.all
	# projects.each do |project|
	# 	pp project
	# end

	# GET All Issues
	issues = client.Issue.all

	# List All Issues
	issues.each do |issue|
		puts "#{issue.id} - #{issue.key}"
		puts "Priority - #{issue.priority.id}"
		puts "#{issue.reporter.displayName}"
		puts "Created - #{Date.parse(issue.created).strftime('%m/%d/%Y')}"
		puts "Updated - #{Date.parse(issue.updated).strftime('%m/%d/%Y')}"
		puts "Last Viewed - #{Date.parse(issue.lastViewed).strftime('%m/%d/%Y')}"
		puts
	end
end