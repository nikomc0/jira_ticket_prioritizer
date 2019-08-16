require 'sinatra'
require 'csv'

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

			if id === '10000' || id === '3'
				slap(ticket, status, created, type)
			end
		end

		def slap(ticket, status, created_date, type)
			created_date = DateTime.parse(created_date).utc
			duedate = ticket.attrs[:duedate]

			# New to Acknowledge Breach
			if status === 'new' && type === 'bug' && DateTime.now.utc >= created_date + (3600 * 24)
				ticket.attrs[:breach] = 'new'
				action_item(ticket, status)

			# Triage Breach 
			elsif status === 'acknowledge' && type === 'bug' && duedate === nil
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
			assignee = "Ping #{ticket.assignee.displayName}"
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
			@array
		end
	end
end