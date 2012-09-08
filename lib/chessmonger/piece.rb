
module Chessmonger

  class Piece
    attr_accessor :player

    def initialize behavior, player = nil
      @behavior, @player = behavior, player
    end

    def each_action game, origin, &block
      @behavior.each_action game, self, origin, &block
    end

    def can_attack? game, origin, target
      @behavior.can_attack? game, self, origin, target
    end
  end
end
