# frozen_string_literal: true

module LAA
  module Cda
    class Hearing
      def initialize(**kwargs)
        @kwargs = kwargs
      end

      def id = @kwargs['id']

      def type
        return if @kwargs['hearing_type'].to_s == ''

        @kwargs['hearing_type']
      end

      def court
        return if @kwargs['court_centre'].nil? || @kwargs['court_centre'].empty?

        @court ||= LAA::Cda::Court.new(**@kwargs['court_centre'])
      end

      def hearing_days
        @hearing_days ||= @kwargs['hearing_days'].to_a.map { |day| LAA::Cda::HearingDay.new(**day) }
      end
    end
  end
end
