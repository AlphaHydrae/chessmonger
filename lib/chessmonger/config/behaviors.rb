
module Chessmonger

  class Config

    class Behaviors

      def initialize
        @behaviors = {}
      end

      def add name, behavior, options = {}
        @behaviors[name] = { :behavior => behavior, :options => options }
      end

      def get name
        @behaviors[name] ? @behaviors[name][:behavior] : nil
      end

      def options name
        @behaviors[name] ? @behaviors[name][:options] : nil
      end

      def delete name
        @behaviors.delete name
      end

      def names
        @behaviors.keys
      end

      def identify behavior
        @behaviors.each_pair do |n,v|
          if behavior == v[:behavior] or behavior.instance_of?(v[:behavior])
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
