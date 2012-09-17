
module Chessmonger

  class Config

    def initialize
      @behaviors = Config::Behaviors.new
      @variants = {}
      @notations = {}
    end

    def behaviors &block
      @behaviors.configure(&block) if block
      @behaviors
    end

    def variant name, impl = nil, &block
      @variants[name] = Config::Variant.new self if impl and !@variants[name]
      @variants[name].implementation = impl if impl
      @variants[name].configure(&block) if block
      @variants[name]
    end

    def variant_names
      @variants.keys
    end

    def identify impl
      @variants.each_pair do |name,variant|
        return name if variant.implementation == impl
      end
      nil
    end

    def notation name, impl = nil, &block
      @notations[name] = Config::Notation.new self if impl and !@notations[name]
      @notations[name].implementation = impl if impl
      @notations[name].configure(&block) if block
      @notations[name]
    end

    def notation_names
      @notations.keys
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
