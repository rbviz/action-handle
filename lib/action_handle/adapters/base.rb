# frozen_string_literal: true

require 'forwardable'

module ActionHandle
  module Adapters
    class Base
      extend Forwardable

      def_delegators Configuration, :logger, :silence_errors

      def taken?(_key)
        raise NotImplementedError
      end

      def current?(_key, _value)
        raise NotImplementedError
      end

      def info(_key)
        raise NotImplementedError
      end

      def claim(_key, _value, _ttl)
        raise NotImplementedError
      end

      def expire(_key)
        raise NotImplementedError
      end

      private

      def perform_with_expectation(expected_response, &block)
        safely_perform(&block) == expected_response
      end

      def safely_perform
        yield
      rescue StandardError => e
        logger.call(e) if logger.respond_to?(:call)

        raise unless silence_errors == true

        false
      end
    end
  end
end
