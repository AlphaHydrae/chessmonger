require 'singleton'

module Chessmonger

  class Rules
    include Singleton

    def initialize
      @rules = {}
    end

    def register name, rules

      [ :number_of_players, :board_width, :board_height, :playing_direction, :pieces, :setup, :allowed? ].each do |method|
        raise ArgumentError, "Rules must implement ##{method}" unless rules.respond_to? method
      end

      unknown_pieces = rules.pieces - Chessmonger.armory.names
      raise ArgumentError, "Rules contain pieces that are not registered in the armory: #{unknown_pieces.join ', '}" if unknown_pieces.any?

      @rules[name] = rules
    end

    def get name
      @rules[name]
    end
  end

  def self.rules
    Rules.instance
  end
end
