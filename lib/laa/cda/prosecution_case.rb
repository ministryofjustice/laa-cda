# frozen_string_literal: true

module LAA
  module Cda
    class ProsecutionCase
      attr_reader :case_number, :status

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
      end
    end
  end
end
