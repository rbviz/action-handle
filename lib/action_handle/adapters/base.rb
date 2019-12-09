# frozen_string_literal: true

module ActionHandle
  module Adapters
    class Base
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
        if logger.respond_to?(:call)
          begin
            yield
          rescue StandardError => e
            logger.call(e)

            false
          end
        else
          yield
        end
      end
    end
  end
end
