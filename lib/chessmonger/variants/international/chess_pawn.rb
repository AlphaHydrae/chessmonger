
module Chessmonger

  module Behavior

    class ChessPawn

      def each_action game, piece, origin

        board = game.board
        dir = game.playing_direction piece.player

        # basic move
        target = dir.from board, origin
        yield self.class.move piece, origin, target if target and board.get(target).nil?

        # diagonal attacks
        [ -1, 1 ].each do |rot|
          target = dir.rotate(rot).from board, origin
          if target
            capture = board.get target
            if capture and game.enemy_piece? piece.player, capture
              yield self.class.move piece, origin, target, capture
            end
          end
        end
      end

      def self.move piece, origin, target, capture = nil
        Chessmonger::Move.new piece.player, piece, origin, target, capture
      end
    end
  end
end
