# frozen_string_literal: true

require 'laa/cda/offence'

RSpec.describe LAA::Cda::Offence do
  subject(:offence) { described_class.new(**offence_data) }

  describe '#title' do
    subject { offence.title }

    context 'with a title' do
      let(:offence_data) { { 'title' => 'Being mean' } }

      it { is_expected.to eq 'Being mean' }
    end

    context 'without a title' do
      let(:offence_data) { {} }

      it { is_expected.to be_nil }
    end
  end

  describe '#pleas' do
    subject(:pleas) { offence.pleas }

    context 'with pleas' do
      let(:offence_data) do
        {
          'pleas' => [
            { 'date' => '2019-10-23', 'value' => 'NO_PLEA' },
            { 'date' => '2019-10-23', 'value' => 'UNFIT_TO_PLEA' },
            { 'date' => '2022-03-14', 'value' => 'GUILTY' }
          ]
        }
      end

      it do
        expect(pleas).to contain_exactly(
          instance_of(LAA::Cda::Plea),
          instance_of(LAA::Cda::Plea),
          instance_of(LAA::Cda::Plea)
        )
      end
    end

    context 'with an empty list of hearing days' do
      let(:offence_data) { { 'pleas' => [] } }

      it { is_expected.to be_empty }
    end

    context 'without a hearing days field' do
      let(:offence_data) { {} }

      it { is_expected.to be_empty }
    end
  end

  describe '#representation_order' do
    subject(:representation_order) { offence.representation_order }

    context 'with a representation order' do
      let(:offence_data) do
        {
          'laa_application' => {
            'reference' => '8765432',
            'status_date' => '2022-03-14',
            'contract_number' => '1234567890'
          }
        }
      end

      it { is_expected.to be_an_instance_of(LAA::Cda::RepresentationOrder) }
      it { expect(representation_order.reference).to eq '8765432' }
      it { expect(representation_order.contract_number).to eq '1234567890' }
      it { expect(representation_order.date).to eq Date.parse('2022-03-14') }
    end

    context 'without a representation order' do
      let(:offence_data) { {} }

      it { is_expected.to be_nil }
    end
  end
end
