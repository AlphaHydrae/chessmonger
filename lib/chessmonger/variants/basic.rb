
module Chessmonger

  module Variants

    class BasicRules

      def setup game
        raise NotImplementedError, '#setup must prepare the board for a new game'
      end

      def current_actions game
        player = current_player game
        [].tap do |actions|
          game.board.each do |piece,pos|
            if piece.player == player
              piece.each_action game, pos do |action|
                game.play action
                actions << action if allowed? game, player
                game.cancel
              end
            end
          end
        end
      end

      def allowed? game, player
        raise NotImplementedError, '#allowed? must indicate whether the current situation is allowed for the specified player'
      end

      def current_player game
        last_action = game.history.last
        if last_action.nil? or game.players.index(last_action.player) == 1
          game.players.first
        else
          game.players[1]
        end
      end

      def playing_direction game, player
        game.players.index(player) == 0 ? Chessmonger::Direction::N : Chessmonger::Direction::S
      end

      def enemy? game, player, other
        player != other
      end

      def board_width
        8
      end

      def board_height
        8
      end

      def number_of_players
        2
      end
    end
  end
end
