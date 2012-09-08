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

    def train name, game, player
      piece = Chessmonger::Piece.new
      behavior = @behaviors[name].create game, piece
      piece.tap do |p|
        p.player = player
        p.behavior = behavior
      end
    end
  end

  def self.armory
    Armory.instance
  end
end
