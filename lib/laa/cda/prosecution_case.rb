# frozen_string_literal: true

module LAA
  module Cda
    class ProsecutionCase
      attr_reader :case_number, :status, :defendants, :hearings

      def self.search(**kwargs)
        JSON.parse(
          LAA::Cda.connection.request(
            :get,
            'api/internal/v2/prosecution_cases',
            params: { filter: kwargs }
          ).body
        )['results'].map { |result| new(**result) }
      end

      def initialize(**kwargs)
        @case_number = kwargs['prosecution_case_reference']
        @status = kwargs['case_status']
        @defendants = kwargs['defendant_summaries'].to_a.map { |defendant| LAA::Cda::Defendant.new(**defendant) }
        @hearings = kwargs['hearing_summaries'].to_a.map { |hearing| LAA::Cda::Hearing.new(**hearing) }
      end
    end
  end
end
