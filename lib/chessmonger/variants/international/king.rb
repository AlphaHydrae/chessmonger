
module Chessmonger

  module Variants

    class InternationalChess

      class King

        def each_action game, piece, origin

          Direction::ALL.each do |dir|

            target = dir.from game.board, origin
            if target
              piece_at_target = game.board.get target
              if piece_at_target.nil?
                yield Move.new piece.player, piece, origin, target
              elsif game.enemy_piece? piece.player, piece_at_target
                yield Move.new piece.player, piece, origin, target, piece_at_target
              end
            end
          end
        end

        def can_attack? game, piece, origin, target
          origin.longest_distance(target) == 1 and origin.distance_product(target) <= 1
        end
      end
    end
  end
end
