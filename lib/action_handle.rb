# frozen_string_literal: true

require 'action_handle/version'
require 'action_handle/configuration'

require 'action_handle/adapters/base'
require 'action_handle/adapters/cache_store'
require 'action_handle/adapters/redis_pool'

require 'action_handle/base'

module ActionHandle
  def self.configure
    Configuration.tap { |it| yield(it) }
  end
end
