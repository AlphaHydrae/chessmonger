
module Chessmonger

  class Direction

    def self.between origin, target
      
      dx, dy = target.x - origin.x, target.y - origin.y
      return nil if dx == 0 and dy == 0

      if dx.abs == dy.abs
        if dx + dy != 0
          dx + dy >= 1 ? NE : SW
        else
          dx - dy >= 1 ? SE : NW
        end
      elsif dx == 0
        dy >= 1 ? N : S
      elsif dy == 0
        dx >= 1 ? E : W
      else
        nil
      end
    end

    def self.smallest_angle_between dir1, dir2
      i1, i2 = ALL.index(dir1), ALL.index(dir2)
      return nil unless i1 and i2
      da = (i2 - i1).abs
      da > 4 ? 8 - da : da
    end

    def initialize dx, dy
      @dx, @dy = dx, dy
    end

    def from board, pos, distance = 1
      board.pos pos.x + distance * @dx, pos.y + distance * @dy
    end

    def rotate n45 = 1
      i = ALL.index self
      return nil unless i
      i = (i + n45) % 8
      ALL[i < 0 ? 8 + i : i ]
    end

    N = Direction.new 0, 1
    NE = Direction.new 1, 1
    E = Direction.new 1, 0
    SE = Direction.new 1, -1
    S = Direction.new 0, -1
    SW = Direction.new -1, -1
    W = Direction.new -1, 0
    NW = Direction.new -1, 1

    ALL = [ N, NE, E, SE, S, SW, W, NW ]
    HORIZONTAL = [ E, W ]
    VERTICAL = [ N, S ]
    STRAIGHT = [ N, E, S, W ]
    DIAGONAL = [ NE, SE, SW, NW ]
  end
end
