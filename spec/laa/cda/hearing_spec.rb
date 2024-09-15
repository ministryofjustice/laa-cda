# frozen_string_literal: true

require 'laa/cda/hearing'

RSpec.describe LAA::Cda::Hearing do
  subject(:hearing) { described_class.new(**hearing_data) }

  describe '#id' do
    subject { hearing.id }

    let(:hearing_data) { { 'id' => '12345678-90ab-cdef-1234-567890abcdef' } }

    it { is_expected.to eq '12345678-90ab-cdef-1234-567890abcdef' }
  end

  describe '#type' do
    subject { hearing.type }

    context 'with a hearing type' do
      let(:hearing_data) { { 'hearing_type' => 'Trial (TRL)' } }

      it { is_expected.to eq 'Trial (TRL)' }
    end

    context 'with a blank hearing type' do
      let(:hearing_data) { { 'hearing_type' => '' } }

      it { is_expected.to be_nil }
    end

    context 'without a hearing type' do
      let(:hearing_data) { {} }

      it { is_expected.to be_nil }
    end
  end

  describe '#court' do
    subject { hearing.court }

    context 'with a court centre' do
      let(:hearing_data) { { 'court_centre' => { 'id' => '12345678-90ab-cdef-1234-567890abcdef' } } }

      it { is_expected.to be_a LAA::Cda::Court }
    end

    context 'with an empty court centre' do
      let(:hearing_data) { { 'court_centre' => {} } }

      it { is_expected.to be_nil }
    end

    context 'without a court centre' do
      let(:hearing_data) { {} }

      it { is_expected.to be_nil }
    end
  end

  describe '#hearing_days' do
    subject(:hearing_days) { hearing.hearing_days }

    context 'with hearing days' do
      let(:hearing_data) do
        {
          'hearing_days' => [
            { 'sitting_day' => '2019-10-26T08:30:00' },
            { 'sitting_day' => '2019-10-26T08:45:00' },
            { 'sitting_day' => '2019-10-26T09:00:00' }
          ]
        }
      end

      it do
        expect(hearing_days).to contain_exactly(
          instance_of(LAA::Cda::HearingDay),
          instance_of(LAA::Cda::HearingDay),
          instance_of(LAA::Cda::HearingDay)
        )
      end
    end

    context 'with an empty list of hearing days' do
      let(:hearing_data) { { 'hearing_days' => [] } }

      it { is_expected.to be_empty }
    end

    context 'without a hearing days field' do
      let(:hearing_data) { {} }

      it { is_expected.to be_empty }
    end
  end
end
