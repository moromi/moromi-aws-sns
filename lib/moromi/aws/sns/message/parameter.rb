require 'json'

module Moromi
  module Aws
    module Sns
      module Message
        class Parameter
          attr_reader :apns_params, :gcm_params

          def initialize(apns_params: {}, gcm_params: {})
            @apns_params = apns_params
            @gcm_params = gcm_params
          end

          def to_json
            {
              'default': '',
              'APNS_SANDBOX': @apns_params.to_json,
              'APNS': @apns_params.to_json,
              'GCM': @gcm_params.to_json
            }
          end
        end
      end
    end
  end
end
