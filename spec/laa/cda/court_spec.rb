# frozen_string_literal: true

require 'laa/cda/court'

RSpec.describe LAA::Cda::Court do
  subject(:court) { described_class.new(**court_data) }

  describe '#id' do
    subject { court.id }

    let(:court_data) { { 'id' => '12345678-90ab-cdef-1234-567890abcdef' } }

    it { is_expected.to eq '12345678-90ab-cdef-1234-567890abcdef' }
  end

  describe '#name' do
    subject { court.name }

    context 'with a name' do
      let(:court_data) { { 'name' => 'Manchester Crown Court' } }

      it { is_expected.to eq 'Manchester Crown Court' }
    end

    context 'without a blank name' do
      let(:court_data) { { 'name' => '' } }

      it { is_expected.to be_nil }
    end

    context 'without a name' do
      let(:court_data) { {} }

      it { is_expected.to be_nil }
    end
  end
end
