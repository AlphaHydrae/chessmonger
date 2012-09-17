
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

    def new_notation name, variant_name
      notation = @config.notation name
      variant = @config.variant variant_name
      notation.implementation.new.tap do |n|
        n.rules_serializer = RulesSerializer.new self
        n.piece_serializer = LetterSerializer.new variant
      end
    end

    def load!
      @config.configure do
        
        behaviors do
          add 'ChessPawn', Variants::InternationalChess::Pawn, :letter => 'p'
          add 'ChessKing', Variants::InternationalChess::King, :letter => 'k'
        end

        variant 'InternationalChess', Variants::InternationalChess.new do
          armory do
            use 'ChessPawn'
            use 'ChessKing'
          end
        end

        notation 'cmgn', Notations::CMGN do
          variants 'InternationalChess'
        end
      end
    end
  end

  def self.rulebook
    @rulebook ||= Rulebook.new.tap{ |book| book.load! }
  end
end
