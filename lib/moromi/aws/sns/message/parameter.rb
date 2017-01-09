require 'json'

module Moromi
  module Aws
    module Sns
      module Message
        class Parameter
          # @param [Moromi::Aws::Sns::Message::Apns] apns
          # @param [Moromi::Aws::Sns::Message::Fcm] gcm
          def initialize(default: '', apns: nil, gcm: nil)
            @default = default
            @apns = apns
            @gcm = gcm
          end

          def to_json
            {
              'default': @default,
              'APNS_SANDBOX': @apns&.to_message_json,
              'APNS': @apns&.to_message_json,
              'GCM': @gcm&.to_message_json
            }.compact.to_json
          end
        end
      end
    end
  end
end
