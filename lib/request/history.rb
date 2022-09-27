# frozen_string_literal: true

require_relative 'history/version'
require_relative 'history/recorder'
require_relative 'history/workers/record_worker'
require_relative 'history/controller_extensions/recording'

module Request
  module History
    class Error < StandardError; end
  end
end
