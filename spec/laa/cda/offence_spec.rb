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
end
