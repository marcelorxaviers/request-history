# frozen_string_literal: true

module Request
  module History
    # Recorder is responsible to write the record for each of the storages available
    class Recorder
      def initialize(storages_names)
        @storages = storages_names.to_a.map(&:constantize)
      end

      def perform(action:, controller:, params:, response_status:, **_whatever)
        @storages.each do |storage|
          next unless storage.respond_to?(:store)

          storage.store(action:, controller:, params:, response_status:)
        end
      end
    end
  end
end
