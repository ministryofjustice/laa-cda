# frozen_string_literal: true

require 'laa/cda/plea'

RSpec.describe LAA::Cda::Plea do
  subject(:plea) { described_class.new(**plea_data) }

  describe '#value' do
    subject { plea.value }

    context 'with a value' do
      let(:plea_data) { { 'value' => 'GUILTY' } }

      it { is_expected.to eq 'GUILTY' }
    end

    context 'with a blank value' do
      let(:plea_data) { { 'value' => '' } }

      it { is_expected.to be_nil }
    end

    context 'without a value' do
      let(:plea_data) { {} }

      it { is_expected.to be_nil }
    end
  end

  describe '#date' do
    subject { plea.date }

    context 'with a date' do
      let(:plea_data) { { 'date' => '2022-03-14' } }

      it { is_expected.to eq Date.new(2022, 3, 14) }
    end

    context 'with a badly formatted date' do
      let(:plea_data) { { 'date' => '1066' } }

      it { is_expected.to be_nil }
    end

    context 'with a blank date' do
      let(:plea_data) { { 'date' => '' } }

      it { is_expected.to be_nil }
    end

    context 'without a date' do
      let(:plea_data) { {} }

      it { is_expected.to be_nil }
    end
  end
end
