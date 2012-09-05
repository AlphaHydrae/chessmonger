
module Chessmonger

  class Position
    attr_reader :x, :y, :index

    def initialize x, y, index
      raise "X must be an integer greater than or equal to 1 (got #{x})" unless x.kind_of?(Fixnum) and x >= 1
      raise "Y must be an integer greater than or equal to 1 (got #{y})" unless y.kind_of?(Fixnum) and y >= 1
      raise "Index must be an integer greater than or equal to 0 (got #{index})" unless index.kind_of?(Fixnum) and index >= 0
      @x, @y, @index = x, y, index
    end
  end
end
