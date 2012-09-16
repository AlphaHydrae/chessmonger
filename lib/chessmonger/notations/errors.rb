
module Chessmonger

  module Notations

    class ConfigError < RuntimeError; end

    class ParseError < RuntimeError
      attr_accessor :line
    end

    class HeaderError < ParseError
      attr_accessor :header
    end

    class UnsupportedVersionError < ParseError; end
  end
end
