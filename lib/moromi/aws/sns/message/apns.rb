module Moromi
  module Aws
    module Sns
      module Message
        class Apns < Base
          PUSH_TYPE_ALERT = 1
          PUSH_TYPE_BACKGROUND = 2

          attr_reader :alert
          attr_reader :badge
          attr_reader :sound
          attr_reader :mutable_content
          attr_reader :category
          attr_reader :priority
          attr_reader :type
          attr_reader :custom_data

          def initialize(alert:, badge:, sound: 'default', push_type: PUSH_TYPE_ALERT, mutable_content: 0, category: nil,
                         priority: 10, type: nil, custom_data: {})
            @alert = alert
            @badge = badge
            @sound = sound
            @push_type = normalize_push_type(push_type)
            @mutable_content = mutable_content
            @category = category
            @priority = priority
            @type = type || self.class.name
            @custom_data = setup_initial_custom_data({type: @type}.merge(custom_data))
          end

          def to_hash
            {
              alert: @alert,
              badge: @badge,
              sound: @sound,
              push_type: @push_type,
              mutable_content: @mutable_content,
              category: @category,
              priority: @priority,
              type: @type,
              custom_data: @custom_data
            }
          end

          def to_message_json
            aps = to_hash
            %i[custom_data type content_available mutable_content].each { |k| aps.delete(k) }
            aps['content-available'] = content_available
            aps['mutable-content'] = @mutable_content
            @custom_data.merge({aps: aps}).to_json
          end

          # https://docs.aws.amazon.com/ja_jp/sns/latest/dg/sns-send-custom-platform-specific-payloads-mobile-devices.html#mobile-push-send-message-apns-background-notification
          def content_available
            case @push_type
            when PUSH_TYPE_ALERT
              'alert'
            when PUSH_TYPE_BACKGROUND
              1
            else
              'alert'
            end
          end

          private

          def setup_initial_custom_data(custom_data)
            custom_data
          end

          def normalize_push_type(value)
            case value
            when PUSH_TYPE_ALERT
              PUSH_TYPE_ALERT
            when PUSH_TYPE_BACKGROUND
              PUSH_TYPE_BACKGROUND
            else
              PUSH_TYPE_ALERT
            end
          end

          class << self
            def build_silent_push_message(priority: 10, custom_data: {})
              new('', nil, sound: nil, push_type: PUSH_TYPE_BACKGROUND, priority: priority, custom_data: custom_data)
            end
          end
        end
      end
    end
  end
end
