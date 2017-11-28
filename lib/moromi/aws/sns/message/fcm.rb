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
                         click_action: nil,
                         body_loc_key: nil, body_loc_args: nil,
                         title_loc_key: nil, title_loc_args: nil,
                         type: nil, custom_data: {})
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
            @type = type || self.class.name
            @custom_data = setup_initial_custom_data({type: @type}.merge(custom_data))
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
              type: @type,
              custom_data: @custom_data
            }
          end

          def to_data_hash
            base = {
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
              type: @type
            }
            flatten_hash(@custom_data).merge(base)
          end

          def to_message_json
            {data: to_data_hash}.to_json
          end

          private

          def setup_initial_custom_data(custom_data)
            custom_data
          end

          def flatten_hash(hash)
            hash.each_with_object({}) do |(k, v), h|
              if v.is_a? Hash
                flatten_hash(v).map do |h_k, h_v|
                  h["#{k}_#{h_k}".to_sym] = h_v
                end
              else
                h[k] = v
              end
            end
          end
        end
      end
    end
  end
end
