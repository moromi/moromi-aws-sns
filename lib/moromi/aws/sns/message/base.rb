module Moromi
  module Aws
    module Sns
      module Message
        module Base
          # @return Moromi::Aws::Sns::Message::Parameter
          def to_parameter
            raise NotImplementedError
          end
        end
      end
    end
  end
end
