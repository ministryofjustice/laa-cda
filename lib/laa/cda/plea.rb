# frozen_string_literal: true

module LAA
  module Cda
    class Plea
      def initialize(**kwargs)
        @kwargs = kwargs
      end

      def value
        return if @kwargs['value'].to_s == ''

        @kwargs['value']
      end

      def date
        return if @kwargs['date'].to_s == ''

        @date ||= Date.parse(@kwargs['date'])
      rescue Date::Error
        nil
      end
    end
  end
end
