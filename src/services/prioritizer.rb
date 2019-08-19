require 'sinatra'

module TicketPrioritizer

	class Prioritizer
		attr_accessor :tickets

		def initialize (tickets, array = [])
			@tickets = tickets
			@array = array
		end

		def get_tickets
			@tickets.each do |ticket|
				ticket_status(ticket)
			end
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

		def slap(ticket, status, created_date, type, duedate)
			created_date = DateTime.parse(created_date).utc
			puts ticket.key


			# New to Acknowledge Breach
			if status === 'new' && type === 'bug' && DateTime.now.utc >= created_date + (3600 * 24)
				ticket.attrs[:breach] = 'new'
				action_item(ticket, status)

			# Triage Breach
			# project = ESUP
			# AND priority in ("P2 - Major", "P3 - Medium")
			# AND type = Bug
			# AND created < -7d
			# AND duedate is EMPTY
			# AND status not in (Closed, Resolved, Done)
			# ORDER BY "Solution / Product Area", created, priority, key ASC

			elsif type === 'bug' && status != 'closed' && status != 'resolved' && status != 'done' && duedate === nil && created_date <= DateTime.now.utc - 7 * (3600 * 24)
				puts "duedate: #{duedate}"
				puts "type #{type} equal to bug: #{type === 'bug'}"
				puts "status #{status} not equal to closed: #{status != 'closed'}"
				puts "status #{status} not equal to resolved: #{status != 'resolved'}"
				puts "status #{status} not equal to done: #{status != 'done'}"
				puts "due date #{duedate} is empty: #{duedate === nil}"
				puts "created date #{created_date} vs. #{DateTime.now.utc - 7 * (3600 * 24)}"
				puts "created date #{created_date} is greater than #{DateTime.now.utc - 7 * (3600 * 24)}: #{created_date <= DateTime.now.utc - 7 * (3600 * 24)}"
				puts

				ticket.attrs[:breach] = 'triage'
				action_item(ticket, status)

			# Regular ticket
			else
				action_item(ticket, status)
			end
		end

		def action_item(ticket, status)
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

		def add_to_ticket_list(ticket)
			@array.push(ticket)
		end

		def get_array
			get_tickets
			puts @tickets.count
			@array
		end
	end
end