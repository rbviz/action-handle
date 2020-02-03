# frozen_string_literal: true

require 'forwardable'

module ActionHandle
  class Base
    extend Forwardable

    BUILTIN_ADAPTERS = {
      redis: Adapters::RedisPool,
      cache: Adapters::CacheStore
    }.freeze

    class << self
      def create(*args, &block)
        new(*args, &block).create
      end

      def expire(*args, &block)
        new(*args, &block).expire
      end

      def renew(*args, &block)
        new(*args, &block).renew
      end
    end

    def create
      adapter.create(key, value, ttl)
    end

    def renew
      adapter.renew(key, value, ttl)
    end

    def taken?
      adapter.taken?(key)
    end

    def current?
      adapter.current?(key, value)
    end

    def info
      adapter.info(key)
    end

    def claim
      adapter.claim(key, value, ttl)
    end

    def expire
      adapter.expire(key)
    end

    def ttl
      defined?(self.class::TTL) ? self.class::TTL : 100
    end

    def value
      true
    end

    def key
      raise NotImplementedError, 'must define `key`'
    end

    def adapter
      @adapter ||=
        case Configuration.adapter
        when Symbol, String
          klass = BUILTIN_ADAPTERS[Configuration.adapter.to_sym]

          klass.new(*Configuration.pool) if klass
        else
          Configuration.adapter
        end
    end
  end
end
