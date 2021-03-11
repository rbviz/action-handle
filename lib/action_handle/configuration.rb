# frozen_string_literal: true

module ActionHandle
  module Configuration
    class << self
      attr_accessor :adapter, :logger, :silence_errors
    end

    module_function

    def adapter(obj = nil)
      @adapter = obj if obj

      @adapter ||= :redis
    end

    def redis_pool
      @redis_pool
    end

    def silence_errors(value = nil)
      @silence_errors = value if value

      @silence_errors ||= false
    end
  end
end
