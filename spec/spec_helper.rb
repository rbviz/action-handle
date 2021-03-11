# frozen_string_literal: true

require 'bundler/setup'
Bundler.setup

require 'fakeredis/rspec'
require 'action_handle'
require 'active_support'

# TODO: remove with fakeredis implementing this
class Redis
  def exists?(key)
    data.key?(key)
  end
end
