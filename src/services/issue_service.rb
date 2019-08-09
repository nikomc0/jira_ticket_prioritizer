require 'sinatra'
require 'json'

class IssueService < Sinatra::Base

	# Enter Sorting Logic to filter tickets based on Priority
	def sort(array)
		[array[1], array[0]]
	end

	def new_to_acknowledge_prioritizer(array)
		arr = []
		
		array.each do |item|
			# P2 Tickets
			if item[:fields][:priority][:id] === 10000
				# item.slap(item[:fields][:status][:name], Date.parse(item[:fields][:created]) >= (3600 * 24))
			end
		end

		arr
	end

	def slap(status, created_date)
		puts status
		puts created_date
	end
end