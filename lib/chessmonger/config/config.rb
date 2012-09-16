
module Chessmonger

  class Config

    def initialize
      @behaviors = Config::Behaviors.new
      @rules = {}
      @notations = {}
    end

    def behaviors &block
      @behaviors.configure(&block) if block
      @behaviors
    end

    def rules name, impl = nil, &block
      @rules[name] = Config::Rules.new self if impl and !@rules[name]
      @rules[name].implementation = impl if impl
      @rules[name].configure(&block) if block
      @rules[name]
    end

    def rule_names
      @rules.keys
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
    end

    def method_missing method, *args, &block
      @self_before_instance_eval.send method, *args, &block
    end
  end
end
