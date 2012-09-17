
module Chessmonger

  class Config

    class Variant
      attr_accessor :implementation

      def initialize config
        @config = config
        @armory = Config::Armory.new config
      end

      def armory &block
        @armory.configure &block if block
        @armory
      end

      def configure &block
        @self_before_instance_eval = eval "self", block.binding
        instance_eval &block
        @self_before_instance_eval = nil
      end

      def method_missing method, *args, &block
        @self_before_instance_eval.send method, *args, &block
      end
    end
  end
end
