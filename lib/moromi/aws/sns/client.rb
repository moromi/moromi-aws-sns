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

        # @param [String] arn
        # @param [Moromi::Aws::Sns::Message::Base] message
        def send_message(arn, message)
          options = {
            target_arn: arn,
            message: message.to_parameter.to_json,
            message_structure: 'json'
          }
          publish(options)
        end

        # @param [String] topic_arn
        # @param [Moromi::Aws::Sns::Message::Base] message
        def send_message_to_topic(topic_arn, message)
          options = {
            topic_arn: topic_arn,
            message: message.to_parameter.to_json,
            message_structure: 'json'
          }
          publish(options)
        end

        def publish(options)
          response = client.publish(options)
          response.message_id
        end

        def get_endpoint_attributes(endpoint_arn)
          params = {
            endpoint_arn: endpoint_arn
          }
          results = client.get_endpoint_attributes(params)
          results.attributes
        end

        private

        def credentials
          @credentials ||= ::Aws::Credentials.new(@access_key_id, @secret_access_key)
        end

        def client
          @client ||= ::Aws::SNS::Client.new(region: @region, credentials: credentials)
        end
      end
    end
  end
end
