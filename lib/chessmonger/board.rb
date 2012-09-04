
module Chessmonger

  class Board

    def initialize width, height
      raise 'Width must be an integer greater than zero' unless width.kind_of?(Fixnum) and width >= 1
      raise 'Height must be an integer greater than zero' unless height.kind_of?(Fixnum) and height >= 1
      @width, @height = width, height
      @contents = Array.new(width * height)
    end

    def get pos
      i = index pos
      i < 0 ? nil : @contents[i]
    end

    def put object, pos
      i = index pos
      return nil if i < 0 or i > @contents.length - 1
      prev = @contents[i]
      @contents[i] = object
      prev
    end

    def take pos
      put nil, pos
    end

    def move origin, target
      put put(nil, origin), target
    end

    def each
      @contents.each do |object|
        yield object if object
      end
    end

    private

    def index pos
      @width * (pos.y - 1) + pos.x - 1
    end
  end
end
