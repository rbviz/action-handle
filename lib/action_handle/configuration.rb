# frozen_string_literal: true

module ActionHandle
  module Configuration
    class << self
      attr_accessor :adapter, :logger, :silence_errors
    end

    module_function

    def adapter
      @adapter ||= Adapters::RedisPool.new
    end

    def silence_errors
      @silence_errors ||= :no
    end
  end
end
