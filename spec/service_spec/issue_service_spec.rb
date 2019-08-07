require_relative "../../src/services/issue_service"

RSpec.describe IssueService do
	subject do
    app = described_class.allocate
    app.send :initialize
    app
  end

	let(:esups) { 
		[{
			key: 'ESUP-2033', 
			fields: { 
				summary: "This is a bug",
				issuetype: { id: '1', name: 'Bug'},
				priority:  { 
					iconUrl: 'https://demandbase.atlassian.net/images/icons/priorities/medium.svg',
					name: 'P3 - Medium',
					id: 3,
				},
				status: {
					name: 'acknowledge',
					statusCategory: {
						key: 'new',
					}
				},
				created: '2019-07-01T10:29:51.105-0700',
				updated: '2019-08-06T22:10:10.724-0700',
				lastViewed: '2019-08-06T11:53:14.534-0700',
			}
		},

		{
			key: 'ESUP-2000', 
			fields: { 
				summary: "This is a bug",
				issuetype: { id: '1', name: 'Bug'},
				priority:  { 
					iconUrl: 'https://demandbase.atlassian.net/images/icons/priorities/medium.svg',
					name: 'P2 - Major',
					id: 10000,
				},
				status: {
					name: 'new',
					statusCategory: {
						key: 'new',
					}
				},
				created: '2019-07-06T10:29:51.105-0700',
				updated: '2019-08-06T22:10:10.724-0700',
				lastViewed: nil,
			}
		}] 
	}

	it 'responds to :sort' do
		expect(subject).to respond_to(:sort)
	end

	it 'sorts by priority' do
		expect(subject.sort(esups)).to eq([esups[1], esups[0]])
	end

	it 'responds to :prioritizer' do
		expect(subject).to respond_to(:prioritizer).with(1).argument
	end

	it 'prioritizes tickets based on SLA'
end
