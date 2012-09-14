
module Chessmonger

  class HQ

    class Rules
      attr_accessor :implementation

      def initialize hq
        @hq = hq
        @armory = Armory.new hq
      end

      def armory &block
        @armory.configure &block if block
        @armory
      end

      def configure &block
        @self_before_instance_eval = eval "self", block.binding
        instance_eval &block
      end

      def method_missing method, *args, &block
        @self_before_instance_eval.send method, *args, &block
      end
    end
  end
end
