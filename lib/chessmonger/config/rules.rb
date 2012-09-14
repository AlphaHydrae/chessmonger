
module Chessmonger

  class Config

    class Rules
      attr_accessor :implementation

      def initialize hq
        @hq = hq
        @armory = Config::Armory.new hq
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
