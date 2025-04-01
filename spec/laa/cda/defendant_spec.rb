# frozen_string_literal: true

require 'laa/cda/defendant'

RSpec.describe LAA::Cda::Defendant do
  subject(:defendant) { described_class.new(**defendant_data) }

  describe '#id' do
    subject { defendant.id }

    let(:defendant_data) { { 'id' => '12345678-90ab-cdef-1234-567890abcdef' } }

    it { is_expected.to eq '12345678-90ab-cdef-1234-567890abcdef' }
  end

  describe '#name' do
    subject { defendant.name }

    context 'with a full name' do
      let(:defendant_data) do
        {
          'first_name' => 'Billy',
          'middle_name' => 'The',
          'last_name' => 'Kid'
        }
      end

      it { is_expected.to eq 'Billy The Kid' }
    end

    context 'without a middle name' do
      let(:defendant_data) do
        {
          'first_name' => 'Al',
          'last_name' => 'Capone'
        }
      end

      it { is_expected.to eq 'Al Capone' }
    end

    context 'with a blank middle name' do
      let(:defendant_data) do
        {
          'first_name' => 'Al',
          'middle_name' => '',
          'last_name' => 'Capone'
        }
      end

      it { is_expected.to eq 'Al Capone' }
    end
  end

  describe '#date_of_birth' do
    subject { defendant.date_of_birth }

    context 'with a date of birth' do
      let(:defendant_data) { { 'date_of_birth' => '1999-05-05' } }

      it { is_expected.to eq Date.parse('1999-05-05') }
    end

    context 'without a date of birth' do
      let(:defendant_data) { {} }

      it { is_expected.to be_nil }
    end

    context 'with a badly formatted date of birth' do
      let(:defendant_data) { { 'date_of_birth' => 'XYZ' } }

      it { is_expected.to be_nil }
    end

    context 'with a date as an integer' do
      let(:defendant_data) { { 'date_of_birth' => 1982 } }

      it { is_expected.to be_nil }
    end
  end

  describe '#arrest_summons_number' do
    subject { defendant.arrest_summons_number }

    context 'with an arrest_summons_number' do
      let(:defendant_data) { { 'arrest_summons_number' => '1234567890AB' } }

      it { is_expected.to eq '1234567890AB' }
    end
  end

  describe '#offences' do
    subject(:offences) { defendant.offences }

    context 'with offence summaries' do
      let(:defendant_data) do
        {
          'offence_summaries' => [
            {}, {}
          ]
        }
      end

      it { is_expected.to contain_exactly(instance_of(LAA::Cda::Offence), instance_of(LAA::Cda::Offence)) }

      context 'when the offences are out of order' do
        let(:defendant_data) do
          {
            'offence_summaries' => [
              { 'order_index' => '2', 'title' => 'Offence 2' },
              { 'order_index' => '3', 'title' => 'Offence 3' },
              { 'order_index' => '1', 'title' => 'Offence 1' }
            ]
          }
        end

        it 'returns the offences in order' do
          expect(offences.map(&:title)).to eq ['Offence 1', 'Offence 2', 'Offence 3']
        end
      end
    end

    context 'with empty offence summaries' do
      let(:defendant_data) { { 'offence_summaries' => [] } }

      it { is_expected.to eq([]) }
    end

    context 'without offence summaries' do
      let(:defendant_data) { {} }

      it { is_expected.to eq([]) }
    end
  end

  describe '#representation_order' do
    subject { defendant.representation_order }

    context 'with an representation_order' do
      let(:defendant_data) do
        {
          'representation_order' => {
            'laa_application_reference' => '1234567',
            'effective_start_date' => '2024-09-01',
            'effective_end_date' => '2024-09-02',
            'laa_contract_number' => '1A234B'
          }
        }
      end

      it { is_expected.to be_an LAA::Cda::RepresentationOrder }
    end

    context 'with an blank representation_order' do
      let(:defendant_data) { { 'representation_order' => {} } }

      it { is_expected.to be_nil }
    end

    context 'without a representation_order' do
      let(:defendant_data) { {} }

      it { is_expected.to be_nil }
    end
  end

  describe '#representation_orders' do
    subject(:representation_orders) { defendant.representation_orders }

    context 'with offences without representation order' do
      let(:defendant_data) do
        {
          'offence_summaries' => [{ 'laa_application' => {} }, { 'laa_application' => {} }]
        }
      end

      it { is_expected.to be_empty }
    end

    context 'with an offence with a representation order' do
      let(:defendant_data) do
        {
          'offence_summaries' => [
            { 'laa_application' => { 'reference' => '8765432', 'status_date' => '2024-09-01',
                                     'contract_number' => '1A234B' } }
          ]
        }
      end

      it { is_expected.to contain_exactly(instance_of(LAA::Cda::RepresentationOrder)) }
      it { expect(representation_orders.first.reference).to eq '8765432' }
      it { expect(representation_orders.first.contract_number).to eq '1A234B' }
      it { expect(representation_orders.first.date).to eq Date.parse('2024-09-01') }
    end

    context 'with multiple offences with different representation orders' do
      let(:defendant_data) do
        {
          'offence_summaries' => [
            {
              'laa_application' => {
                'reference' => '8765432', 'status_date' => '2024-09-01', 'contract_number' => '1A234B'
              }
            },
            {
              'laa_application' => {
                'reference' => '1234567', 'status_date' => '2024-09-02', 'contract_number' => '1A234C'
              }
            }
          ]
        }
      end

      it do
        expect(representation_orders).to contain_exactly(
          instance_of(LAA::Cda::RepresentationOrder), instance_of(LAA::Cda::RepresentationOrder)
        )
      end

      it { expect(representation_orders[0].reference).to eq '8765432' }
      it { expect(representation_orders[0].contract_number).to eq '1A234B' }
      it { expect(representation_orders[0].date).to eq Date.parse('2024-09-01') }
      it { expect(representation_orders[1].reference).to eq '1234567' }
      it { expect(representation_orders[1].contract_number).to eq '1A234C' }
      it { expect(representation_orders[1].date).to eq Date.parse('2024-09-02') }
    end

    context 'with multiple offences with the same representation order' do
      let(:defendant_data) do
        {
          'offence_summaries' => [
            {
              'laa_application' => {
                'reference' => '8765432', 'status_date' => '2024-09-01', 'contract_number' => '1A234B'
              }
            },
            {
              'laa_application' => {
                'reference' => '8765432', 'status_date' => '2024-09-01', 'contract_number' => '1A234B'
              }
            }
          ]
        }
      end

      it { is_expected.to contain_exactly(instance_of(LAA::Cda::RepresentationOrder)) }
      it { expect(representation_orders[0].reference).to eq '8765432' }
      it { expect(representation_orders[0].contract_number).to eq '1A234B' }
      it { expect(representation_orders[0].date).to eq Date.parse('2024-09-01') }
    end
  end
end
