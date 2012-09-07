
module Chessmonger

  class Position
    attr_reader :x, :y, :index

    def initialize x, y, index
      raise "X must be greater than or equal to 1 (got #{x})" unless x >= 1
      raise "Y must be greater than or equal to 1 (got #{y})" unless y >= 1
      raise "Index must be greater than or equal to 0 (got #{index})" unless index >= 0
      @x, @y, @index = x, y, index
    end
  end
end
