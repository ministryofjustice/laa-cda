# frozen_string_literal: true

module LAA
  module Cda
    class Offence
      def initialize(**kwargs)
        @kwargs = kwargs
      end

      def title = @kwargs['title']

      def pleas
        @pleas ||= @kwargs['pleas'].to_a.map { |plea| LAA::Cda::Plea.new(**plea) }
      end
    end
  end
end
