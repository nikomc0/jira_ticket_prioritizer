require 'sinatra'
require 'sinatra/base'
require 'json'

class IssueService
	# Enter Sorting Logic to filter tickets based on Priority
	def sort
		["test", "test2"]
	end

	def new_to_acknowledge_prioritizer(array)
		arr = []

		array.each do |item|
			id = item.priority.id
			status = item.status.name
			created = item.created

			# Checks for P2 and P3 Tickets that are new and older than 24 hours.
			if id === '10000' || id === '3'

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

		if status === 'New' && DateTime.now >= created_date + (24/24)
			true
		end
	end
end