# frozen_string_literal: true

require 'laa/cda/configuration'
require 'laa/cda/prosecution_case'

module LAA
  module Cda
    class << self
      def configuration
        @configuration ||= Configuration.new
      end

      def configure
        yield(configuration) if block_given?
        configuration
      end

      def connection = @configuration.connection
    end
  end
end
