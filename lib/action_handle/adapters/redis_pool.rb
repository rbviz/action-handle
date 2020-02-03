# frozen_string_literal: true

require 'redis'
require 'connection_pool'

module ActionHandle
  module Adapters
    class RedisPool < Base
      CurrentRedisWapper = Class.new do
        def with
          yield(Redis.current)
        end
      end

      def initialize(pool = nil)
        @pool = pool || CurrentRedisWapper.new
      end

      def create(key, value, ttl)
        perform_with_expectation(true) do
          @pool.with do |client|
            client.set(key, value, ex: ttl, nx: true)
          end
        end
      end

      def renew(key, value, ttl)
        perform_with_expectation(true) do
          @pool.with do |client|
            client.expire(key, ttl) if current?(key, value)
          end
        end
      end

      def taken?(key)
        perform_with_expectation(true) do
          @pool.with { |client| client.exists(key) }
        end
      end

      def current?(key, value)
        perform_with_expectation(value.to_s) do
          @pool.with { |client| client.get(key) }
        end
      end

      def value(key)
        safely_perform do
          @pool.with { |client| client.get(key) }
        end
      end

      def claim(key, value, ttl)
        perform_with_expectation('OK') do
          @pool.with do |client|
            client.set(key, value, ex: ttl)
          end
        end
      end

      def expire(key)
        perform_with_expectation(1) do
          @pool.with { |client| client.del(key) }
        end
      end
    end
  end
end
