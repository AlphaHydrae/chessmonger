
module Chessmonger

  class Rulebook

    class LetterSerializer

      def initialize variant
        @variant = variant
      end

      def save piece, game
        id = @variant.armory.identify piece.behavior
        @variant.armory.options(id)[:letter]
      end

      def match? piece, name, game
        save(piece, game) == name
      end
    end
  end
end
