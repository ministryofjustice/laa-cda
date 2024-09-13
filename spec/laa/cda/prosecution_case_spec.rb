# frozen_string_literal: true

require 'laa/cda/prosecution_case'

RSpec.describe LAA::Cda::ProsecutionCase do
  let(:connection) { instance_double(OAuth2::AccessToken) }

  describe 'Class methods' do
    describe '.search' do
      subject(:cases) { described_class.search(**search_params) }

      before do
        LAA::Cda.configure do |conf|
          conf.root_url = 'http://example.com'
          conf.oauth2_id = 'oauth2_id'
          conf.oauth2_secret = 'oauth2_secret'
        end

        stub_request(:post, 'http://example.com/oauth/token')
          .with(body: { grant_type: 'client_credentials' })
          .to_return(
            status: 200,
            body: {
              access_token: 'jy70F_BkOxJEMosKWYmBwWQzxtG36T2aCIz1ENGoyGk',
              token_type: 'Bearer',
              expires_in: 300,
              created_at: Time.now.to_i
            }.to_json,
            headers: { 'content-type': 'application/json' }
          )

        stub_request(:get, 'http://example.com/api/internal/v2/prosecution_cases')
          .with(query: hash_including({ filter: search_params }))
          .to_return(
            status: 200, body: response_data.to_json,
            headers: { 'content-type': 'application/json' }
          )
      end

      context 'with a name and date of birth' do
        let(:search_params) { { name: 'Arthur Raffles', date_of_birth: '1939-08-17' } }
        let(:response_data) do
          {
            total_results: 2,
            results: [
              { prosecution_case_reference: 'TEST12345', case_status: 'INACTIVE' },
              { prosecution_case_reference: 'TEST54321', case_status: 'ACTIVE' }
            ]
          }
        end

        it { is_expected.to contain_exactly(instance_of(described_class), instance_of(described_class)) }
        it { expect(cases[0].case_number).to eq 'TEST12345' }
        it { expect(cases[0].status).to eq 'INACTIVE' }
        it { expect(cases[1].case_number).to eq 'TEST54321' }
        it { expect(cases[1].status).to eq 'ACTIVE' }
      end
    end
  end

  describe 'Instance methods' do
    subject(:prosecution_case) { described_class.new(**case_data) }

    describe '#case_number' do
      subject { prosecution_case.case_number }

      let(:case_data) { { 'prosecution_case_reference' => 'ABC123' } }

      it { is_expected.to eq 'ABC123' }
    end

    describe '#status' do
      subject { prosecution_case.status }

      let(:case_data) { { 'case_status' => 'ACTIVE' } }

      it { is_expected.to eq 'ACTIVE' }
    end
  end
end
