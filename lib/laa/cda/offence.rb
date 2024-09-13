# frozen_string_literal: true

module LAA
  module Cda
    class Offence
      def initialize(**kwargs)
        @kwargs = kwargs
      end

      def title = @kwargs['title']
    end
  end
end
