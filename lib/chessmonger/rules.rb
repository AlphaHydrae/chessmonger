require 'singleton'

module Chessmonger

  class Rules
    include Singleton

    def initialize
      @rules = {}
    end

    def register name, rules
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
