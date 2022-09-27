# frozen_string_literal: true

module Request
  module History
    # This worker is used to save the record independent on the main server process/thread.
    # The application using it has to have the sidekiq running therefore.
    class RecordWorker
      include Sidekiq::Worker

      def perform(record_attributes)
        Recorder.new(record_attributes.delete('storages')).then do |recorder|
          recorder.perform(**record_attributes.symbolize_keys)
        end
      end
    end
  end
end
