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
			id = item[:fields][:priority][:id]
			status = item[:fields][:status][:name]
			created = item[:fields][:created]

			# Checks for P2 and P3 Tickets that are new and older than 24 hours.
			if id === 10000 || id === 3
				# If the ticket is new and older than 24 hours add to the arr object
				if self.slap(status, created)
					arr.push(item)
				end
			end
		end

		arr
	end

	def slap(status, created_date)
		created_date = DateTime.parse(created_date)

		if status === 'new' && DateTime.now >= created_date + (24/24)
			true
		end
	end
end