# frozen_string_literal: true

require 'laa/cda/defendant'

RSpec.describe LAA::Cda::Defendant do
  subject(:defendant) { described_class.new(**defendant_data) }

  describe '#id' do
    subject { defendant.id }

    context 'with an arrest_summons_number' do
      let(:defendant_data) { { 'id' => '12345678-90ab-cdef-1234-567890abcdef' } }

      it { is_expected.to eq '12345678-90ab-cdef-1234-567890abcdef' }
    end
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
    subject { defendant.offences }

    context 'with offence summaries' do
      let(:defendant_data) do
        {
          'offence_summaries' => [
            {}, {}
          ]
        }
      end

      it { is_expected.to contain_exactly(instance_of(LAA::Cda::Offence), instance_of(LAA::Cda::Offence)) }
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
end
