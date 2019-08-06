require_relative "../../src/controllers/issue_controller"

RSpec.describe IssueController do
	subject do
		app = described_class.allocate
		app.send :initialize
		app
	end

	it 'expects an array of issues' do
		expect(subject.esups).not_to be_empty
	end
end
