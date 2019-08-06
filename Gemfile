source 'https://rubygems.org'

group :production do
	gem 'pg'
end

group :test do
	gem 'rspec'
	gem 'guard'
	gem 'guard-rspec'
	gem 'rack-test'
end

group :development do
	# Where the magic begins
	gem 'sinatra'

	gem 'rake'

	# Easy way to require all files required in app to DRY up require's
	gem 'require_all'

	# Auto reloading of the application when code changes have been made
	gem 'shotgun'

	# Testing Tools for Database and Business Logic
	gem 'pry'
	gem 'pry-remote'
	gem 'tux'
	gem 'byebug'

	# Active Record connection
	gem 'sinatra-activerecord'
	# To Create Error messages for end user.
	gem 'sinatra-flash'

	# Gem for interacting with JIRA
	# Potentially re-write internally to remove dependency
	gem 'jira-ruby'
	# Making Simple HTTP requests

	gem 'httparty'
	# Secure Environment Variables

	gem 'dotenv'
end
