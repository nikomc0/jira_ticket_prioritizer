require 'sinatra'
require_relative 'action'

module TicketPrioritizer

	class Prioritizer
		attr_accessor :tickets

		def initialize (args, array = [])
			@array = array
			post_initialize(args)
		end

		def post_initialize(args)
			nil
		end

		def get_tickets(tickets)
			tickets.each do |ticket|
				ticket_status(ticket)
			end
		end

		def ticket_status(ticket)
			action_item(ticket)
		end

		def add_to_ticket_list(ticket)
			@array.push(ticket)
		end
	end

	class Bugs < Prioritizer
		def post_initialize(args)
			@bugs = args[:bugs]
		end

		def get_array
			get_tickets(@bugs)
			@array
		end
		
		def ticket_status(ticket)
			id = ticket.priority.id
			status = ticket.status.name.downcase
			created = ticket.created
			type = ticket.issuetype.name.downcase
			duedate = ticket.duedate
			
			if id === '10000' || id === '3'
				slap(ticket, status, created, type, duedate)
			end
		end

		# Checks SLA requirements
		def slap(ticket, status, created_date, type, duedate)
			created_date = DateTime.parse(created_date).utc

			# New to Acknowledge Breach
			if status === 'new' && type === 'bug' && DateTime.now.utc >= created_date + (3600 * 24)
				ticket.attrs[:breach] = 'new'
				action_item(ticket)

			# Triage Breach
			elsif type === 'bug' && status != 'closed' && status != 'resolved' && status != 'done' && duedate === nil && created_date <= DateTime.now.utc - 7 * (3600 * 24)
				ticket.attrs[:breach] = 'triage'
				action_item(ticket)

			# Regular ticket
			else
				action_item(ticket)
			end
		end

		def action_item(ticket)
			status = ticket.status.name
			customer = 'Ping Customer'
			support = 'QA'
			assignee = "Ping Product"
			pm = 'Ping Product Manager'

			action = ticket.attrs[:action]
			breach = ticket.attrs[:breach]

			if status === 'fixed in prod'
				ticket.attrs[:action] = customer
				add_to_ticket_list(ticket)
			elsif status === 'resolved'
				ticket.attrs[:action] = support
				add_to_ticket_list(ticket)
			elsif breach === 'new'
				ticket.attrs[:action] = pm
				add_to_ticket_list(ticket)
			elsif breach === 'triage'
				ticket.attrs[:action] = assignee
				add_to_ticket_list(ticket)
			end
		end
	end

	class Tasks < Prioritizer
		def post_initialize(args)
			@tasks = args[:tasks]
		end

		def get_array
			get_tickets(@tasks)
			@array
		end

		def action_item(ticket)
			Action.new(ticket)
			add_to_ticket_list(ticket)
		end

		# Assign specific action items
	end
end