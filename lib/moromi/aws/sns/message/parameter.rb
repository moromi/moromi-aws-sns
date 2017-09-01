require 'json'

module Moromi
  module Aws
    module Sns
      module Message
        class Parameter
          def initialize(apns: nil, gcm: nil)
            @apns = apns
            @gcm = gcm
          end

          def to_json
            {
              'default': '',
              'APNS_SANDBOX': @apns&.to_json,
              'APNS': @apns&.to_json,
              'GCM': @gcm&.to_json
            }.compact.to_json
          end
        end
      end
    end
  end
end
