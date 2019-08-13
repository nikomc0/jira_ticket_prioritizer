require_relative "../../src/services/issue_service"

RSpec.shared_context 'common' do
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
				# created: DateTime.now.new_offset(Rational(0, 24)).to_s,
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
				# created: DateTime.now.new_offset(Rational(0, 24)).to_s,
				updated: '2019-08-06T22:10:10.724-0700',
				lastViewed: nil,
			}
		}]
	}
end

RSpec.describe IssueService do
	include_context 'common'

	before do
		esups
	end
	# it 'responds to :sort' do
	# 	expect(subject).to respond_to(:sort)
	# end

	# it 'sorts by priority' do
	# 	expect(subject.sort(esups)).to eq([esups[1], esups[0]])
	# end


	it 'responds to :new_to_acknowledge_prioritizer' do
		expect(subject).to respond_to(:new_to_acknowledge_prioritizer).with(1).argument
	end

	it 'responds to :slap' do
		expect(subject).to respond_to(:slap).with(2).argument
	end

	context 'the New to Acknowledge prioritizer' do

		# context 'with P0 tickets' do
		# 	it 'prioritizes new P0 tickets that are older than 10 min'
		# end

		# context'with P1 tickets' do
		# 	it 'prioritizes new P1 tickets that are older than 10 min'
		# end

		context 'with P2 tickets' do
			it 'prioritizes new P2 tickets that are older than 24 hrs' do
				expect(subject.new_to_acknowledge_prioritizer(esups)).to eq([esups[1]])
			end
		end

		context 'with P3 tickets' do
			it 'prioritizes new P3 tickets that are older than 24 hrs' do
				esups.push({
					key: 'ESUP-2040',
					fields: {
						priority:  {
							iconUrl: 'https://demandbase.atlassian.net/images/icons/priorities/medium.svg',
							name: 'P3 - Medium',
							id: 3,
						},
						status: {
							name: 'new',
						},
						created: '2019-07-01T10:29:51.105-0700',
						# created: DateTime.now.new_offset(Rational(0, 24)).to_s,
					}
				}.to_json)

				expect(subject.new_to_acknowledge_prioritizer(esups)).to match_array([esups[1], esups[2]])
			end
		end
	end

	# context 'the Triage prioritizer' do
	# 	it 'prioritizes acknowledge P0 tickets that are older than 15 min'
	# 	it 'prioritizes acknowledge P1 tickets that are older than 30 min'
	# 	it 'prioritizes acknowledge P2 tickets that are older than 1 week'
	# 	it 'prioritizes acknowledge P3 tickets that are older than 1 week'
	# end

	# context 'the Response prioritizer' do
	# 	it 'prioritizes in progress P0 tickets that are older than 15 min'
	# 	it 'prioritizes in progress P1 tickets that are older than 30 min'
	# 	it 'prioritizes in progress P2 tickets that are older than 24 hrs'
	# 	it 'prioritizes in progress P3 tickets that are older that 48 hrs'
	# end

	# context 'the Customer Response prioritizer' do
	# 	it 'prioritzes tickets newly marked as resolved'
	# end
end
