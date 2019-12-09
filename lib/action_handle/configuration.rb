# frozen_string_literal: true

module ActionHandle
  module Configuration
    class << self
      attr_accessor :adapter
    end

    module_function

    def adapter
      @adapter ||= Adapters::RedisPool.new
    end
  end
end
