require 'json'

module Moromi
  module Aws
    module Sns
      class Client
        def initialize(access_key_id, secret_access_key, region)
          @access_key_id = access_key_id
          @secret_access_key = secret_access_key
          @region = region
        end

        def register(platform_application_arn, token, force_enable: true)
          params = {
            platform_application_arn: platform_application_arn,
            token: token
          }

          response = client.create_platform_endpoint(params)
          arn = response.endpoint_arn

          if force_enable
            params = {
              endpoint_arn: arn,
              attributes: {'Enabled' => 'true'}
            }
            client.set_endpoint_attributes(params)
          end

          arn
        end

        def subscribe(topic_arn, endpoint_arn)
          params = {
            topic_arn: topic_arn,
            protocol: 'application',
            endpoint: endpoint_arn
          }
          response = client.subscribe(params)
          response.subscription_arn
        end

        def unsubscribe(subscription_arn)
          params = {
            subscription_arn: subscription_arn
          }
          client.unsubscribe(params)
        end

        def inactive(arn)
          params = {
            endpoint_arn: arn,
            attributes: {'Enabled' => 'false'}
          }
          client.set_endpoint_attributes(params)
        end

        def send_apns(arn, params)
          options = {
            target_arn: arn,
            message: build_apns_json_message(params),
            message_structure: 'json'
          }
          publish(options)
        end

        def send_apns_to_topic(topic_arn, params)
          options = {
            topic_arn: topic_arn,
            message: build_apns_json_message(params),
            message_structure: 'json'
          }
          publish(options)
        end

        def publish(options)
          response = client.publish(options)
          response.message_id
        end

        private

        def credentials
          @credentials ||= ::Aws::Credentials.new(@access_key_id, @secret_access_key)
        end

        def client
          @client ||= ::Aws::SNS::Client.new(region: @region, credentials: credentials)
        end

        def build_apns_json_message(params)
          {
            'default': '',
            'APNS_SANDBOX' => params.to_json,
            'APNS' => params.to_json
          }.to_json
        end
      end
    end
  end
end
