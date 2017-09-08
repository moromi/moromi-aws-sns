module Moromi
  module Aws
    module Sns
      module Message
        class Apns < Base
          attr_reader :alert
          attr_reader :badge
          attr_reader :sound
          attr_reader :content_available
          attr_reader :mutable_content
          attr_reader :category
          attr_reader :priority
          attr_reader :type
          attr_reader :custom_data

          def initialize(alert:, badge:, sound: 'default', content_available: 1, mutable_content: 0, category: nil,
                         priority: 10, type: nil, custom_data: {})
            @alert = alert
            @badge = badge
            @sound = sound
            @content_available = content_available
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
              content_available: @content_available,
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
            aps['content-available'] = @content_available
            aps['mutable-content'] = @mutable_content
            @custom_data.merge({aps: aps}).to_json
          end

          private

          def setup_initial_custom_data(custom_data)
            custom_data
          end

          class << self
            def build_silent_push_message(priority: 10, custom_data: {})
              new('', nil, sound: nil, content_available: 1, priority: priority, custom_data: custom_data)
            end
          end
        end
      end
    end
  end
end
