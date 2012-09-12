require 'singleton'

module Chessmonger

  class Rules
    include Singleton

    def initialize
      @rules = {}
    end

    def register name, rules

      [
        :number_of_players, :board_width, :board_height, :playing_direction,
        :setup, :current_actions, :current_player, :enemy?
      ].each do |method|
        raise ArgumentError, "Rules must implement ##{method}" unless rules.respond_to? method
      end

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
