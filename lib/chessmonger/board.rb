
module Chessmonger

  class Board
    attr_reader :width, :height

    def initialize width, height
      raise ArgumentError, 'Width must be greater than zero' unless width >= 1
      raise ArgumentError, 'Height must be greater than zero' unless height >= 1

      @width, @height, @length = width, height, width * height

      @positions = Array.new(width * height) do |i|
        y = (i / width.to_f).floor
        x = i - y * width + 1
        Position.new x, y + 1, i
      end

      @contents = Array.new(@positions.length)
    end

    def get pos
      @contents[pos.index]
    end

    def put object, pos
      @contents[pos.index].tap do
        @contents[pos.index] = object
      end
    end

    def take pos
      put nil, pos
    end

    def move origin, target
      put put(nil, origin), target
    end

    def each
      @contents.each_with_index do |object,i|
        yield object, @positions[i] if object
      end
    end

    def pos x, y
      return nil if x < 1 or y < 1
      @positions[index(x, y)]
    end

    private

    def index x, y
      @width * (y - 1) + x - 1
    end
  end
end
