# frozen_string_literal: true

require 'laa/cda/prosecution_case'

RSpec.describe LAA::Cda::ProsecutionCase do
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
              {
                prosecution_case_reference: 'TEST12345', case_status: 'INACTIVE',
                defendant_summaries: [
                  {
                    id: '12345678-90ab-cdef-1234-567890abcdef',
                    first_name: 'Tom',
                    middle_name: '',
                    last_name: 'Cobley',
                    arrest_summons_number: '1234567890AB',
                    date_of_birth: '2000-12-27'
                  },
                  {
                    id: '12345678-90ab-cdef-1234-567890abcdee',
                    first_name: 'Arthur',
                    middle_name: 'Justice',
                    last_name: 'Raffles',
                    arrest_summons_number: '1234567890AC',
                    date_of_birth: '1939-08-17'
                  }
                ]
              },
              { prosecution_case_reference: 'TEST54321', case_status: 'ACTIVE' }
            ]
          }
        end

        it { is_expected.to contain_exactly(instance_of(described_class), instance_of(described_class)) }

        it { expect(cases[0].case_number).to eq 'TEST12345' }
        it { expect(cases[1].case_number).to eq 'TEST54321' }

        it { expect(cases[0].status).to eq 'INACTIVE' }
        it { expect(cases[1].status).to eq 'ACTIVE' }

        it do
          expect(cases[0].defendants)
            .to contain_exactly(instance_of(LAA::Cda::Defendant), instance_of(LAA::Cda::Defendant))
        end

        it { expect(cases[1].defendants).to eq([]) }
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

    describe '#hearings' do
      subject { prosecution_case.hearings }

      let(:case_data) do
        {
          'hearing_summaries' => [
            {
              'id' => '12345678-90ab-cdef-1234-567890abcdef',
              'hearing_type' => 'Trial (TRL)',
              'court_centre' => {
                'id' => '12345678-90ab-cdef-1234-567890abcdef',
                'name' => 'Manchester Crown Court'
              },
              'hearing days' => [
                { 'sitting_day' => '2019-10-26T08:30:00' },
                { 'sitting_day' => '2019-10-26T08:45:00' },
                { 'sitting_day' => '2019-10-26T09:00:00' }
              ]
            },
            {
              'id' => '12345678-90ab-cdef-1234-567890abcdee',
              'hearing_type' => 'Pre-Trial Review (TRL)',
              'court_centre' => {
                'id' => '12345678-90ab-cdef-1234-567890abcdee',
                'name' => 'Derby Crown Court'
              },
              'hearing days' => [{ 'sitting_day' => '2019-10-26T08:30:00' }]
            }
          ]
        }
      end

      it { is_expected.to contain_exactly(instance_of(LAA::Cda::Hearing), instance_of(LAA::Cda::Hearing)) }
    end
  end
end
