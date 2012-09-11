
module Chessmonger

  class Piece
    attr_accessor :behavior, :player

    def initialize behavior = nil, player = nil
      @behavior, @player = behavior, player
    end

    def each_action game, origin, &block
      @behavior.each_action game, self, origin, &block
    end

    def actions game, origin
      [].tap do |actions|
        each_action game, origin do |action|
          actions << action
        end
      end
    end

    def can_attack? game, origin, target
      @behavior.can_attack? game, self, origin, target
    end
  end
end
