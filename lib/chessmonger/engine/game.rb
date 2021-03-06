
module Chessmonger

  class Game

    attr_reader :rules, :players, :board, :history, :status, :captures

    def initialize rules, players

      raise ArgumentError, "Rules require #{rules.number_of_players} players (got #{players.length})" unless players.length == rules.number_of_players

      @rules, @players = rules, players

      @board = Board.new rules.board_width, rules.board_height
      @history = []
      @captures = {}
      @status = :ongoing
    end

    def play action
      action.play self
      history << action
    end

    def cancel
      history.pop.cancel self
    end

    def current_player
      @rules.current_player self
    end

    def current_actions
      @rules.current_actions self
    end

    def enemy_piece? player, piece
      @rules.enemy? self, player, piece.player
    end

    def playing_direction player
      @rules.playing_direction self, player
    end
  end
end
