# frozen_string_literal: true

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require 'minitest'
require 'minitest/mock'
require 'sidekiq/api'
require 'mocha/minitest'

require_relative '../../dummy/config/environment'
ENV['RAILS_ROOT'] ||= "#{File.dirname(__FILE__)}../../../test/dummy"

require 'rails/test_help'
