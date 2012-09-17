
module Chessmonger

  class Rulebook
  
    class RulesSerializer

      def initialize rulebook
        @rulebook = rulebook
      end

      def save rules
        @rulebook.config.identify rules
      end

      def load name
        @rulebook.config.variant(name).implementation
      end
    end
  end
end
