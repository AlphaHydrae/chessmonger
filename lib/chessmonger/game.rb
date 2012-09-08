
module Chessmonger

  class Game

    attr_reader :rules, :players, :board, :history, :status

    def initialize rules, players

      raise ArgumentError, "Rules require #{rules.number_of_players} players (got #{players.length})" unless players.length == rules.number_of_players

      @rules, @players = rules, players

      @board = Board.new rules.board_width, rules.board_height
      @history = []
      @status = :ongoing

      @rules.setup self
    end

    def play action
      action.play self
      history << action
    end

    def cancel
      history.pop.cancel self
    end

    def player
      @rules.player self
    end

    def actions
      @rules.actions self
    end

    def enemy_piece? player, piece
      @rules.enemy? self, player, piece.player
    end
  end
end
