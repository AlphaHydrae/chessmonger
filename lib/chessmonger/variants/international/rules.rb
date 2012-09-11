
module Chessmonger

  module Variants

    class InternationalChess

      def setup game
        pawn = Behavior::ChessPawn.new
        8.times do |i|
          game.board.put Piece.new(pawn, game.players[0]), game.board.pos(i + 1, 2)
          game.board.put Piece.new(pawn, game.players[1]), game.board.pos(i + 1, 7)
        end
      end

      def current_player game
        last_action = game.history.last
        if last_action.nil? or game.players.index(last_action.player) == 1
          game.players.first
        else
          game.players[1]
        end
      end

      def playing_direction game, player
        game.players.index(player) == 0 ? Chessmonger::Direction::N : Chessmonger::Direction::S
      end

      def enemy? game, player, other
        player != other
      end

      def board_width
        8
      end

      def board_height
        8
      end

      def number_of_players
        2
      end
    end
  end
end

dirname = File.dirname __FILE__
[
  :chess_pawn
].each{ |lib| require File.join dirname, lib.to_s }
