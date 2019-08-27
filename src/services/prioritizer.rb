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
			updated = DateTime.parse(ticket.updated).utc

			# New to Acknowledge Breach
			if status === 'new' && type === 'bug' && DateTime.now.utc >= created_date + (3600 * 24)
				breach = 'new'
				action_item(ticket, breach)

			# Triage Breach
			elsif type === 'bug' && status != 'closed' && status != 'resolved' && status != 'done' && duedate === nil && created_date <= DateTime.now.utc - 7 * (3600 * 24)
				breach= 'triage'
				action_item(ticket, breach)
			elsif status != 'closed' && status != 'resolved' && status != 'done' && ticket.comments.last && ticket.comments.last.author['displayName'] != ticket.creator['displayName'] && updated >= updated + (3600 * 24)
				breach = 'support'
				action_item(ticket, breach)
			end
		end

		def action_item(ticket, breach)
			Action.new({ticket: ticket, breach: breach}).set_action
			add_to_ticket_list(ticket)
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

		def ticket_status(ticket)
			slap(ticket)
		end

		def slap(ticket)
			if ticket.comments.last && ticket.comments.last.author['displayName'] != ticket.creator['displayName']
				question = ticket.comments.last.author['displayName']
				action_item(ticket, question)
			end
		end

		def action_item(ticket, question)
			Action.new({ticket: ticket, question: question}).set_action
			add_to_ticket_list(ticket)
		end

		# Assign specific action items
	end
end