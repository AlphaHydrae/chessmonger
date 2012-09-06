
module Chessmonger

  class Player

    attr_reader :name

    def initialize name
      raise "Name must be a string (got #{name.class.name})" unless name.kind_of?(String) and !name.strip.empty?
      @name = name
    end
  end
end
