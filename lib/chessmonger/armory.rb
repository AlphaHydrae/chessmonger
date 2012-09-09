require 'singleton'

module Chessmonger

  class Armory
    include Singleton

    def initialize
      @behaviors = {}
    end

    def register behavior, options = {}
      raise ArgumentError, 'Behavior must respond to :create' unless behavior.respond_to? :create
      raise ArgumentError, 'Behavior must respond to :name' unless behavior.respond_to? :name
      name = options[:name] || behavior.name
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
      check behavior, name
      piece.tap do |p|
        p.player = player
        p.behavior = behavior
      end
    end

    private

    def check behavior, name
      raise ArgumentError, "Behavior #{name} must respond to :each_action" unless behavior.respond_to?(:each_action)
      raise ArgumentError, "Behavior #{name} must respond to :can_attack?" unless behavior.respond_to?(:can_attack?)
      raise ArgumentError, "Behavior #{name} must respond to :name" unless behavior.respond_to?(:name)
      raise ArgumentError, "Behavior #{name} must respond to :name=" unless behavior.respond_to?(:name=)
    end
  end

  def self.armory
    Armory.instance
  end
end
