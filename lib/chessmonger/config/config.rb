
module Chessmonger

  class Config

    def initialize
      @behaviors = Config::Behaviors.new
      @rules = {}
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

    def configure &block
      @self_before_instance_eval = eval "self", block.binding
      instance_eval &block
    end

    def method_missing method, *args, &block
      @self_before_instance_eval.send method, *args, &block
    end
  end
end
