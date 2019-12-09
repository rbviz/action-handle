# frozen_string_literal: true

require 'action_handle/version'
require 'action_handle/configuration'
require 'action_handle/base'

require 'action_handle/adapters/base'
require 'action_handle/adapters/rails_cache'
require 'action_handle/adapters/redis_pool'

module ActionHandle
  def self.configure
    yield(Configuration)
  end
end
