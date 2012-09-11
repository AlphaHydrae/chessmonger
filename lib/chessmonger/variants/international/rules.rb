
module Chessmonger

  module Variants

    class InternationalChess < BasicRules

      def setup game

        board = game.board

        pawn = Behavior::ChessPawn.new
        8.times do |i|
          board.put Piece.new(pawn, game.players[0]), board.pos(i + 1, 2)
          board.put Piece.new(pawn, game.players[1]), board.pos(i + 1, 7)
        end

        king = Behavior::ChessKing.new
        board.put Piece.new(king, game.players[0]), board.pos(5, 1)
        board.put Piece.new(king, game.players[1]), board.pos(4, 8)
      end
    end
  end
end

dirname = File.dirname __FILE__
[
  :chess_king, :chess_pawn
].each{ |lib| require File.join dirname, lib.to_s }
