
module Chessmonger

  class Direction

    def initialize dx, dy
      raise 'dx must be an integer' unless dx.kind_of? Fixnum
      raise 'dy must be an integer' unless dy.kind_of? Fixnum
      @dx, @dy = dx, dy
    end

    def from board, pos, distance = 1
      board.pos pos.x + distance * @dx, pos.y + distance * @dy
    end

    N = Direction.new 0, 1
    NE = Direction.new 1, 1
    E = Direction.new 1, 0
    SE = Direction.new 1, -1
    S = Direction.new 0, -1
    SW = Direction.new -1, -1
    W = Direction.new -1, 0
    NW = Direction.new -1, 1
  end
end
