require 'json'

module Moromi
  module Aws
    module Sns
      module Message
        class Base
          def to_hash
            raise NotImplementedError
          end

          def to_message_json
            raise NotImplementedError
          end

          def ==(other)
            to_hash == other.to_hash
          end

          class << self
            def build_from_hash(hash)
              new(hash)
            end
          end
        end
      end
    end
  end
end
