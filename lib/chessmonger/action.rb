
module Chessmonger

  class Action

    attr_reader :player

    def initialize player
    
      raise "Player must be a #{Player.name} (got #{player.class.name})" unless player.kind_of?(Player)

      @player = player
    end

    def play game
      raise '#play has not been implemented'
    end

    def cancel game
      raise '#cancel has not been implemented'
    end
  end
end
