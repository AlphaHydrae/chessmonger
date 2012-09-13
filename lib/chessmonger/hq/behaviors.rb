
module Chessmonger

  class HQ

    class Behaviors

      def initialize
        @behaviors = {}
      end

      def add name, behavior
        @behaviors[name] = behavior
      end

      def get name
        @behaviors[name]
      end

      def delete name
        @behaviors.delete name
      end

      def names
        @behaviors.keys
      end

      def identify behavior
        @behaviors.each_pair do |n,b|
          if behavior == b or behavior.instance_of?(b)
            return n
          end
        end
        nil
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
