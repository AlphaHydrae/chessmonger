
module Chessmonger

  module Distance

    def self.horizontal origin, target
      target.x - origin.x
    end

    def self.vertical origin, target
      target.y - origin.y
    end

    def self.longest origin, target
      [ (target.x - origin.x).abs, (target.y - origin.y).abs ].max
    end

    def self.product origin, target
      (target.x - origin.x).abs * (target.y - origin.y).abs
    end
  end
end
