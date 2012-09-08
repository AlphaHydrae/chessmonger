
module Chessmonger

  class Piece
    attr_accessor :behavior, :player

    def each_action origin, &block
      @behavior.each_action origin, &block
    end

    def can_attack? origin, target
      @behavior.can_attack? origin, target
    end
  end
end
