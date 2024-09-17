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
end
