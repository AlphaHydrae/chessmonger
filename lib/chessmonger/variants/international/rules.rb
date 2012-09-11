
module Chessmonger

  module Variants

    class InternationalChess < BasicRules

      def setup game
        pawn = Behavior::ChessPawn.new
        8.times do |i|
          game.board.put Piece.new(pawn, game.players[0]), game.board.pos(i + 1, 2)
          game.board.put Piece.new(pawn, game.players[1]), game.board.pos(i + 1, 7)
        end
      end
    end
  end
end

dirname = File.dirname __FILE__
[
  :chess_king, :chess_pawn
].each{ |lib| require File.join dirname, lib.to_s }
