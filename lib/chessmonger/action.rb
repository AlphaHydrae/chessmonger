
module Chessmonger

  class Action

    attr_reader :player

    def initialize player
      @player = player
    end

    def play game
      raise NotImplementedError, '#play has not been implemented'
    end

    def cancel game
      raise NotImplementedError, '#cancel has not been implemented'
    end
  end
end
