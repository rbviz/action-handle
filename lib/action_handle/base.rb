# frozen_string_literal: true

module ActionHandle
  class Base
    BUILTIN_ADAPTERS = {
      redis: Adapters::RedisPool,
      cache: Adapters::CacheStore
    }.freeze

    class << self
      def prefix(string = nil)
        @prefix = string if string
        @prefix
      end

      def ttl(amount = nil)
        @ttl = amount if amount
        @ttl ||= 100
        @ttl
      end

      def create(*args, &block)
        new(*args, &block).create
      end

      def expire(*args, &block)
        new(*args, &block).expire
      end

      def renew(*args, &block)
        new(*args, &block).renew
      end

      def claim(*args, &block)
        new(*args, &block).claim
      end

      def value(*args, &block)
        new(*args, &block).value
      end
    end

    attr_reader :key, :instance_value

    def initialize(key, instance_value = nil)
      @key = key
      @instance_value = instance_value
    end

    def create
      adapter.create(handle_key, instance_value, ttl)
    end

    def renew
      adapter.renew(handle_key, instance_value, ttl)
    end

    def taken?
      adapter.taken?(handle_key)
    end

    def current?
      adapter.current?(handle_key, instance_value)
    end

    def value
      adapter.value(handle_key)
    end

    def claim
      adapter.claim(handle_key, instance_value, ttl)
    end

    def expire
      adapter.expire(handle_key)
    end

    def ttl
      self.class.ttl
    end

    def handle_key
      ['AH', self.class.prefix, key].join('/')
    end

    def adapter
      @adapter ||=
        case Configuration.adapter
        when Symbol, String
          klass = BUILTIN_ADAPTERS[Configuration.adapter.to_sym]

          klass.new(*Configuration.redis_pool) if klass
        else
          Configuration.adapter
        end
    end
  end
end
