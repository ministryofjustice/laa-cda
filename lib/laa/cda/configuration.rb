# frozen_string_literal: true

require 'oauth2'

module LAA
  module Cda
    class Configuration
      attr_accessor :root_url, :oauth2_id, :oauth2_secret

      def connection
        @connection = nil if @connection&.expired?

        @connection ||= client.client_credentials.get_token
      end

      private

      def client = @client ||= OAuth2::Client.new(@oauth2_id, @oauth2_secret, site: @root_url)
    end
  end
end
