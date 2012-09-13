require 'singleton'

module Chessmonger

  class HQ

    def initialize
      @behaviors = Chessmonger::HQ::Behaviors.new
    end

    def behaviors &block
      @behaviors.configure(&block) if block
      @behaviors
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
