# frozen_string_literal: true

require 'laa/cda/representation_order'

RSpec.describe LAA::Cda::RepresentationOrder do
  subject(:representation_order) { described_class.new(**representation_order_data) }

  describe '#reference' do
    subject { representation_order.reference }

    context 'with a reference' do
      let(:representation_order_data) { { 'laa_application_reference' => '1234567' } }

      it { is_expected.to eq '1234567' }
    end

    context 'without a reference' do
      let(:representation_order_data) { {} }

      it { is_expected.to be_nil }
    end
  end

  describe '#start' do
    subject { representation_order.start }

    context 'with a start' do
      let(:representation_order_data) { { 'effective_start_date' => '2022-03-14' } }

      it { is_expected.to eq Date.new(2022, 3, 14) }
    end

    context 'with a badly formatted start' do
      let(:representation_order_data) { { 'effective_start_date' => '1066' } }

      it { is_expected.to be_nil }
    end

    context 'with a blank start' do
      let(:representation_order_data) { { 'effective_start_date' => '' } }

      it { is_expected.to be_nil }
    end

    context 'without a start' do
      let(:representation_order_data) { {} }

      it { is_expected.to be_nil }
    end
  end

  describe '#end' do
    subject { representation_order.end }

    context 'with a end' do
      let(:representation_order_data) { { 'effective_end_date' => '2022-03-14' } }

      it { is_expected.to eq Date.new(2022, 3, 14) }
    end

    context 'with a badly formatted end' do
      let(:representation_order_data) { { 'effective_end_date' => '1066' } }

      it { is_expected.to be_nil }
    end

    context 'with a blank end' do
      let(:representation_order_data) { { 'effective_end_date' => '' } }

      it { is_expected.to be_nil }
    end

    context 'without a end' do
      let(:representation_order_data) { {} }

      it { is_expected.to be_nil }
    end
  end

  describe '#contract_number' do
    subject { representation_order.contract_number }

    context 'with a contract_number' do
      let(:representation_order_data) { { 'laa_contract_number' => '1234567' } }

      it { is_expected.to eq '1234567' }
    end

    context 'without a contract_number' do
      let(:representation_order_data) { {} }

      it { is_expected.to be_nil }
    end
  end
end
