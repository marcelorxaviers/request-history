# frozen_string_literal: true

module Request
  module History
    # This is the auxiliary module to be included in any controllers in which we desire to record
    # the request.
    #
    # It is important to notice that the way it is implemented here it used a puma mechanism
    # (rack.after_reply) that ensures its execution wouldn't affect the request performance, ie,
    # the code is executed after the request is fulfilled.
    #
    # Another important remark is that is executed inside a worker, so that we release the main
    # process and thread to serve incoming requests.
    module Recording
      extend ActiveSupport::Concern
      class_methods do
        attr_reader :parameters_to_record, :storages

        # It works as any other rails' action callback, but defaulting to record method:
        # recording params: [:name], except: :show, if: -> { params["name"].present? }
        #
        # Check what are the possible options at:
        # https://api.rubyonrails.org/v7.0.3.1/classes/AbstractController/Callbacks/ClassMethods.html
        def recording(**options, &)
          @async = options.delete(:async)
          @parameters_to_record = Array.wrap(options.delete(:params))
          @storages = options.delete(:storages).then { _1.present? ? Array.wrap(_1) : [] }

          after_action(:record, **options, &)
        end

        # By default we execute it asynchronously
        def async?
          @async.nil? || @async.is_a?(TrueClass)
        end
      end

      private

      # We use map instead of permit to also deal with required parameters
      # Also changed to record params as json, instead of hash
      def parameters_to_record
        self.class.parameters_to_record.map { [_1, params[_1]] }.to_h.to_json
      end

      def data_to_record
        {
          action: params[:action],
          params: parameters_to_record,
          controller: params[:controller],
          response_status: response.status,
          storages: self.class.storages.map(&:to_s)
        }
      end

      # This is called after any controller action but it does everything in background, so that
      # we do not hijack the request to perform non functional requirements.
      def record # rubocop:disable Metrics/AbcSize
        return unless request.env['rack.after_reply'].is_a?(Array)

        # Pumas provides this mechanism to execute a piece of code right after the response is
        # sent to the caller. This makes the request to do not be affected by aspects of the code,
        # such as, logs, tracking information or any other non functional requirements.
        request.env['rack.after_reply'] << lambda {
          # Running async frees up the server to go back serving requests instead of taking care
          # of adjacent behaviours
          #
          # We need to stringify_keys in order to follow sidekiq best practises:
          # https://github.com/mperham/sidekiq/wiki/Best-Practices
          return RecordWorker.perform_async(**data_to_record.stringify_keys) if self.class.async?

          Recorder.new(data_to_record[:storages]).perform(**data_to_record)
        }
      end
    end
  end
end
