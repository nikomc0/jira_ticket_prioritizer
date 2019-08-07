require 'sinatra'

class IssueService < Sinatra::Base

	# Enter Sorting Logic to filter tickets based on Priority
	def sort(array)
		[array[1], array[0]]
	end

	def prioritizer(array)
		puts array
	end
end