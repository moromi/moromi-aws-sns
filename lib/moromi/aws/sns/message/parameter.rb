require 'json'

module Moromi
  module Aws
    module Sns
      module Message
        class Parameter
          # @param [Moromi::Aws::Sns::Message::Apns] apns
          # @param [Moromi::Aws::Sns::Message::Fcm] gcm
          def initialize(apns: nil, gcm: nil)
            @apns = apns
            @gcm = gcm
          end

          def to_hash
            {
              klass_name: self.class.name,
              apns: {name: @apns&.class&.name, data: @apns&.to_hash},
              gcm: {name: @gcm&.class&.name, data: @gcm&.to_hash}
            }
          end

          def to_json
            {
              'default': '',
              'APNS_SANDBOX': @apns&.to_message_json,
              'APNS': @apns&.to_message_json,
              'GCM': @gcm&.to_message_json
            }.compact.to_json
          end

          def self.build_from_hash(hash)
            apns_klass = hash.dig(:apns, :name)&.safe_constantize
            apns = apns_klass&.build_from_hash(hash.dig(:apns, :data))

            gcm_klass = hash.dig(:gcm, :name)&.safe_constantize
            gcm = gcm_klass&.build_from_hash(hash.dig(:gcm, :data))

            new(apns: apns, gcm: gcm)
          end
        end
      end
    end
  end
end
