
module Chessmonger

  class Rulebook
    attr_reader :config

    def initialize
      @config = Config.new
    end

    def new_game variant, players
      registered = @config.variant variant
      raise ArgumentError, "Unknown variant #{variant}" unless registered
      game = Game.new registered.implementation, players
      registered.implementation.setup game
      game
    end

    def load!
      @config.configure do
        
        behaviors do
          add 'ChessPawn', Chessmonger::Variants::InternationalChess::Pawn, :letter => 'p'
          add 'ChessKing', Chessmonger::Variants::InternationalChess::King, :letter => 'k'
        end

        variant 'InternationalChess', Chessmonger::Variants::InternationalChess.new do
          armory do
            use 'ChessPawn'
            use 'ChessKing'
          end
        end
      end
    end
  end

  def self.rulebook
    @rulebook ||= Rulebook.new.tap{ |book| book.load! }
  end
end
