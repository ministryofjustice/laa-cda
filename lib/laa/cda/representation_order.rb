# frozen_string_literal: true

module LAA
  module Cda
    class RepresentationOrder
      def initialize(**kwargs)
        @kwargs = kwargs
      end

      def reference = @reference ||= @kwargs['reference'] || @kwargs['laa_application_reference']
      def date = @date ||= Date.parse(@kwargs['status_date'])
      def contract_number = @contract_number = @kwargs['contract_number'] || @kwargs['laa_contract_number']

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

      def eql?(other)
        return false unless other.is_a?(self.class)

        reference == other.reference
      end
    end
  end
end
