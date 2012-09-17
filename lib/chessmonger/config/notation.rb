
module Chessmonger

  class Config

    class Notation
      attr_reader :implementation
      attr_reader :supported_variants

      def initialize config
        @config = config
        @supported_variants = []
      end

      def implementation= impl
        raise ArgumentError, 'Notation implementation must respond to #new' unless impl.nil? or impl.respond_to?(:new)
        @implementation = impl
      end

      def variants *names
        registered = @config.variant_names
        names.each do |name|
          raise ArgumentError, "Unknown variant #{name}" unless registered.include? name
        end
        @supported_variants.concat names
      end

      def create
        raise ArgumentError, 'Implementation must be set before creating' unless @implementation
        @implementation.new
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
