require 'singleton'

module Chessmonger

  class Armory
    include Singleton

    def initialize
      @behaviors = {}
    end

    def register name, behavior
      raise ArgumentError, 'Behavior must respond to :create' unless behavior.respond_to? :create
      @behaviors[name] = behavior
    end

    def get name
      @behaviors[name]
    end

    def names
      @behaviors.keys
    end

    def train name, game, player = nil
      behavior = @behaviors[name].create game
      Chessmonger::Piece.new behavior, player
    end
  end

  def self.armory
    Armory.instance
  end
end
