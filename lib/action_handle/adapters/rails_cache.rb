# frozen_string_literal: true

module ActionHandle
  module Adapters
    class RailsCache < Base
      def initialize(cache = nil)
        @client = cache
      end

      def create(key, value, ttl)
        perform_with_expectation(true) do
          client.write(key, value, expires_in: ttl) unless taken?(key)
        end
      end

      def renew(key, value, ttl)
        perform_with_expectation(true) do
          client.write(key, value, expires_in: ttl) if current?(key, value)
        end
      end

      def taken?(key)
        perform_with_expectation(true) do
          client.exist?(key)
        end
      end

      def current?(key, value)
        perform_with_expectation(value.to_s) do
          client.read(key)
        end
      end

      def info(key)
        safely_perform { client.read(key) }
      end

      def claim(key, value, ttl)
        perform_with_expectation(true) do
          client.write(key, value, expires_in: ttl)
        end
      end

      def expire(key)
        perform_with_expectation(true) do
          client.delete(key)
        end
      end

      private

      def client
        @client ||= ::Rails.cache
      end
    end
  end
end
