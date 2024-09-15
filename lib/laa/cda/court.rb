# frozen_string_literal: true

module LAA
  module Cda
    class Court
      def initialize(**kwargs)
        @kwargs = kwargs
      end

      def id = @kwargs['id']

      def name
        return if @kwargs['name'].to_s == ''

        @kwargs['name']
      end
    end
  end
end
