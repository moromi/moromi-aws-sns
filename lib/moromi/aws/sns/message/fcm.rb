module Moromi
  module Aws
    module Sns
      module Message
        class Fcm < Base
          # https://firebase.google.com/docs/cloud-messaging/http-server-ref?hl=ja#notification-payload-support
          attr_reader :title
          attr_reader :body
          attr_reader :android_channel_id
          attr_reader :icon
          attr_reader :sound
          attr_reader :tag
          attr_reader :color
          attr_reader :click_action
          attr_reader :body_loc_key
          attr_reader :body_loc_args
          attr_reader :title_loc_key
          attr_reader :title_loc_args

          def initialize(title: nil, body: nil, android_channel_id: nil, icon: nil, sound: nil, tag: nil, color: nil,
                         click_action: nil, body_loc_key: nil, body_loc_args: nil, title_loc_key: nil, title_loc_args: nil,
                         custom_data: {})
            @title = title
            @body = body
            @android_channel_id = android_channel_id
            @icon = icon
            @sound = sound
            @tag = tag
            @color = color
            @click_action = click_action
            @body_loc_key = body_loc_key
            @body_loc_args = body_loc_args
            @title_loc_key = title_loc_key
            @title_loc_args = title_loc_args
            @custom_data = setup_initial_custom_data(custom_data)
          end

          def to_hash
            {
              title: @title,
              body: @body,
              android_channel_id: @android_channel_id,
              icon: @icon,
              sound: @sound,
              tag: @tag,
              color: @color,
              click_action: @click_action,
              body_loc_key: @body_loc_key,
              body_loc_args: @body_loc_args,
              title_loc_key: @title_loc_key,
              title_loc_args: @title_loc_args,
              custom_data: @custom_data
            }
          end

          def to_message_json
            notification = to_hash
            notification.delete(:custom_data)
            {notification: notification, data: @custom_data}.to_json
          end

          private

          def setup_initial_custom_data(custom_data)
            custom_data
          end
        end
      end
    end
  end
end
