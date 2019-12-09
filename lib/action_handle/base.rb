# frozen_string_literal: true

require 'forwardable'

module ActionHandle
  class Base
    extend Forwardable

    def_delegator :Configuration, :adapter

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
  end
end
