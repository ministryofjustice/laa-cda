# frozen_string_literal: true

module LAA
  module Cda
    class Defendant
      def initialize(**kwargs)
        @kwargs = kwargs
      end

      def id = @kwargs['id']
      def arrest_summons_number = @kwargs['arrest_summons_number']
      def name = [first_name, middle_name, last_name].reject { |n| n.to_s == '' }.join(' ')

      def date_of_birth
        Date.parse(@kwargs['date_of_birth'])
      rescue Date::Error, TypeError
        nil
      end

      def offences = @kwargs['offence_summaries'].to_a.map { |offence| LAA::Cda::Offence.new(**offence) }

      private

      def first_name = @kwargs['first_name']
      def middle_name = @kwargs['middle_name']
      def last_name = @kwargs['last_name']
    end
  end
end
