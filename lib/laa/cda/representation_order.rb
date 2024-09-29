# frozen_string_literal: true

module LAA
  module Cda
    class RepresentationOrder
      def initialize(**kwargs)
        @kwargs = kwargs
      end

      def reference = @kwargs['laa_application_reference']
      def contract_number = @kwargs['laa_contract_number']

      def start
        return if @kwargs['effective_start_date'].to_s == ''

        @start ||= Date.parse(@kwargs['effective_start_date'])
      rescue Date::Error
        nil
      end

      def end
        return if @kwargs['effective_end_date'].to_s == ''

        @end ||= Date.parse(@kwargs['effective_end_date'])
      rescue Date::Error
        nil
      end
    end
  end
end
