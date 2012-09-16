
module Chessmonger

  module Notations

    class Error < RuntimeError; end

    class ConfigError < Error
      attr_accessor :config
    end

    class ParseError < Error
      attr_accessor :line
    end

    class HeaderError < ParseError
      attr_accessor :header
    end

    class UnsupportedVersionError < ParseError; end
  end
end
