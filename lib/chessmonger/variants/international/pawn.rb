
module Chessmonger

  module Variants

    class InternationalChess

      class Pawn

        def each_action game, piece, origin

          board = game.board
          dir = game.playing_direction piece.player

          # basic move
          target = dir.from board, origin
          if target and board.get(target).nil?
            yield Chessmonger::Move.new piece.player, piece, origin, target
          end

          # diagonal attacks
          [ -1, 1 ].each do |rot|
            target = dir.rotate(rot).from board, origin
            if target
              capture = board.get target
              if capture and game.enemy_piece? piece.player, capture
                yield Chessmonger::Move.new piece.player, piece, origin, target, capture
              end
            end
          end
        end

        def can_attack? game, piece, origin, target
          dir = Chessmonger::Direction.between origin, target
          playing_dir = game.playing_direction piece.player
          origin.longest_distance(target) == 1 and Chessmonger::Direction.smallest_angle_between(dir, playing_dir) == 1
        end
      end
    end
  end
end
