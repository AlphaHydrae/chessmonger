
# TODO: improve error messages

module Chessmonger

  class Config

    class Armory

      def initialize config
        @config = config
        @behaviors = {}
      end

      def use *args
        name = args.shift
        behavior = @config.behaviors.get(name)
        raise ArgumentError, "No such behavior #{name}" unless behavior
        options = args.last.kind_of?(Hash) ? args.pop : {}
        options = @config.behaviors.options(name).merge options
        @behaviors[name] = { :behavior => behavior, :options => options }
      end

      def get name
        @behaviors[name] ? @behaviors[name][:behavior] : nil
      end

      def options name
        @behaviors[name] ? @behaviors[name][:options].dup : nil
      end

      def copy rules_name
        rules = @config.rules rules_name
        raise ArgumentError, "No such rules #{rules_name}" unless rules
        rules.armory.names.each do |n|
          use n, rules.armory.options(n)
        end
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

      def delete name
        @behaviors.delete name
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
