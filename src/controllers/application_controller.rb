require 'dotenv'
require 'pp'
require 'jira-ruby'

Dotenv.load('.env')

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
	pp "Priority - #{issue.priority.id}"
	pp "#{issue.reporter.displayName}"
	puts "Create - #{issue.created}"
	puts "Updated - #{issue.updated}"
	puts "Last Viewed - #{issue.lastViewed}"
	puts
end