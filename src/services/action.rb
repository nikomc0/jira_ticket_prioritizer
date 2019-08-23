class Action
	attr_accessor :ticket, :breach, :question

	def initialize(args)
		@ticket = args[:ticket]
		@breach = args.fetch(:breach, false)
		@question = args.fetch(:question, false)
	end

	def set_action
		customer = 'Ping Customer'
		support_to_test = 'QA'
		support = "Follow Up"
		assignee = "Ping #{ticket.assignee.displayName}"
		pm = 'Ping Product Manager'
		question = "#{@question} responded."
		# confirm = "#{ticket.creator.displayName} to QA"

		status = ticket.status.name
		
		ticket.attrs[:breach] = breach

		if breach === 'new'
			ticket.attrs[:action] = pm
		elsif breach === 'triage'
			ticket.attrs[:action] = assignee
		elsif breach === 'support'
			ticket.attrs[:action] = support
		elsif status === 'fixed in prod'
			ticket.attrs[:action] = customer
		elsif status === 'resolved'
			ticket.attrs[:action] = support_to_test
		elsif question
			ticket.attrs[:action] = question
		end
	end
end
