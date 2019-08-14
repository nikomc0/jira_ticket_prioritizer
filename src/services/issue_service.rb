require 'sinatra'
require 'sinatra/base'
require 'csv'

class Prioritizer
	attr_accessor :tickets

	def initialize (tickets, array = [])
		@tickets = tickets
		@array = array
	end

	# iterates over the array
	def get_tickets
		puts "Getting Tickets..."
		@tickets.each do |ticket|
			ticket_status(ticket)
		end
	end

	# Checks for only P2 and P3 tickets
	def ticket_status(ticket)
		puts "Checking Ticket Status"

		id = ticket.priority.id
		status = ticket.status.name
		created = ticket.created

		if id === '10000' || id === '3'
			slap(ticket, status, created)
		end
	end

	# Checks for SLA breach
	def slap(ticket, status, created_date)
		puts "Checking if the ticket breached SLA"
		created_date = Date.parse(created_date)

		if status === 'New' && DateTime.now >= created_date + (24/24)
			add_to_ticket_list(ticket)
		else
			puts 'Sending to get action item'
			action_item(ticket, status)
		end
	end

	# Assigns an Action Item
	def action_item(ticket, status)
		puts "Assigning an action item"
		puts ticket.key
		customer = 'Ping Customer'
		engineer = 'Ping Engineer'
		support = 'QA'
		pm = 'Ping Product Manager'

		if status.downcase === 'resolved' || status.downcase === 'fixed in production'
			ticket.attrs.merge!(action: customer)
			ticket
			add_to_ticket_list(ticket)
		end
	end

	# Add to the array
	def add_to_ticket_list(ticket)
		puts "Adding to the array"
		@array.push(ticket)
		@array
	end
end