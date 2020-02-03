# frozen_string_literal: true

require 'memoist'

module ActionHandle
  module Configuration
    extend Memoist

    class << self
      attr_accessor :adapter, :logger, :silence_errors
    end

    module_function

    memoize def adapter
      @adapter ||= :redis
    end

    memoize def redis_pool
      @redis_pool
    end

    memoize def silence_errors
      @silence_errors || false
    end
  end
end
