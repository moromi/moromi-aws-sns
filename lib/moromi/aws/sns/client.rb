require 'json'

module Moromi
  module Aws
    module Sns
      class Client
        def initialize(access_key_id, secret_access_key, region, platform_application_arn)
          @access_key_id = access_key_id
          @secret_access_key = secret_access_key
          @region = region
          @platform_application_arn = platform_application_arn
        end

        def register(token:, force_enable: true)
          params = {
            platform_application_arn: @platform_application_arn,
            token: token
          }
          params[:attributes] = {'Enabled' => 'true'} if force_enable

          response = client.create_platform_endpoint(params)
          response[:endpoint_arn]
        end

        def subscribe(topic_arn:, endpoint_arn:)
          params = {
            topic_arn: topic_arn,
            protocol: 'application',
            endpoint: endpoint_arn
          }
          client.subscribe(params)
        end

        def inactive(arn:)
          params = {
            endpoint_arn: arn,
            attributes: {'Enabled' => 'false'}
          }
          client.set_endpoint_attributes(params)
        end

        def send_apns(arn:, params:, sandbox: true)
          options = {
            target_arn: arn,
            message: build_apns_json_message(params, sandbox),
            message_structure: 'json'
          }
          client.publish(options)
        end

        def send_apns_to_topic(topic_arn:, params:, sandbox: true)
          options = {
            topic_arn: topic_arn,
            message: build_apns_json_message(params, sandbox),
            message_structure: 'json'
          }
          client.publish(options)
        end

        private

        def credentials
          @credentials ||= ::Aws::Credentials.new(@access_key_id, @secret_access_key)
        end

        def client
          @client ||= ::Aws::SNS::Client.new(region: @region, credentials: credentials)
        end

        def build_apns_json_message(params, sandbox)
          endpoint = sandbox ? 'APNS_SANDBOX' : 'APNS'
          {endpoint => params.to_json}.to_json
        end
      end
    end
  end
end
