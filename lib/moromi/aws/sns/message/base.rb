module Moromi
  module Aws
    module Sns
      module Message
        module Base
          # @return Moromi::Aws::Sns::Message::Parameter
          def to_parameter
            raise NotImplementedError
          end

          def serialize
            raise NotImplementedError
          end

          # @return Moromi::Aws::Sns::Message::Base
          def self.unserialize(data)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
