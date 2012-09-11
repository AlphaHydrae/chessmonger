
module Chessmonger

  class Position
    attr_reader :x, :y, :index

    def initialize x, y, index
      raise ArgumentError, "X must be greater than or equal to 1 (got #{x})" unless x >= 1
      raise ArgumentError, "Y must be greater than or equal to 1 (got #{y})" unless y >= 1
      raise ArgumentError, "Index must be greater than or equal to 0 (got #{index})" unless index >= 0
      @x, @y, @index = x, y, index
    end

    def == other
      x == other.x and y == other.y
    end

    def horizontal_distance target
      target.x - @x
    end

    def vertical_distance target
      target.y - @y
    end

    def longest_distance target
      [ (target.x - @x).abs, (target.y - @y).abs ].max
    end

    def distance_product target
      (target.x - @x).abs * (target.y - @y).abs
    end
  end
end
