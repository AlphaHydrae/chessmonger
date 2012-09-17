
module Chessmonger

  class Move

    attr_reader :player, :piece, :origin, :target, :capture

    def initialize player, piece, origin, target, capture = nil
      @player, @piece, @origin, @target, @capture = player, piece, origin, target, capture
    end

    def play game
      game.board.move @origin, @target
      (game.captures[@player] ||= []) << @capture if @capture
    end

    def cancel game
      game.board.move @target, @origin
      if @capture
        game.captures[@player].delete @capture
        game.board.put @capture, @target
      end
    end
  end
end
