
module Chessmonger

  class Game

    attr_reader :rules, :players, :board, :history, :status

    def initialize rules, players

      raise ArgumentError, "Rules require #{rules.number_of_players} players (got #{players.length})" unless players.length == rules.number_of_players

      @rules, @players = rules, players

      @board = Board.new rules.board_width, rules.board_height
      @history = []
      @status = :ongoing
    end

    def play action
      action.play self
      history << action
    end

    def cancel
      history.pop.cancel self
    end

    def player
      @rules.current_player self
    end
  end
end
