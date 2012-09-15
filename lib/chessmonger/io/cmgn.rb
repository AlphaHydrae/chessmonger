
module Chessmonger

  module IO

    class ConfigError < RuntimeError; end

    class ParseError < RuntimeError
      attr_reader :line

      def initialize line = nil, msg = nil
        super msg
        @line = line
      end
    end

    class HeaderError < ParseError
      attr_reader :header

      def initialize header, line = nil, msg = nil
        super line, msg
        @header = header
      end
    end

    class UnsupportedVersionError < ParseError; end

    class CMGN
      VERSION = 1

      attr_accessor :rules_serializer
      attr_accessor :piece_serializer

      def save game
        contents = String.new
        contents << "CMGN #{VERSION}"
        contents << "\nRules #{@rules_serializer.save(game.rules)}"
        game.players.each_with_index{ |p,i| contents << "\nP#{i + 1} #{p.name}" }
        contents << "\n"
        game.history.each do |action|
          # TODO: add action registration
          player = game.players.index(action.player) + 1
          piece = piece_serializer.save action.piece, game
          origin = "#{action.origin.x},#{action.origin.y}"
          target = "#{action.target.x},#{action.target.y}"
          contents << "\n#{player}. #{piece}:#{origin}-#{target}"
        end
        contents
      end

      def load contents

        if !rules_serializer
          raise ConfigError, 'A rules serializer must be set'
        end

        lines = contents.split "\n"

        if lines.empty?
          error "No contents found"
        end

        # check version
        @line = 1
        version_line = lines.shift
        unless m = version_line.match(/^CMGN (\d+)/)
          error %/First line must be "CMGN n" where n is the format version number/
        end
        version = m[1].to_i
        if version != 1
          error UnsupportedVersionError, %/CMGN version #{version} is not supported/
        end

        # parse headers
        headers = {}
        while lines.any? and lines.first != ''
          @line += 1
          m = lines.shift.match(/^([A-Za-z0-9]+) (.*)$/)
          if !m
            error %/Expected a header or an empty line, got "#{lines.first}"/
          end
          headers[m[1]] = m[2]
        end

        if !headers['Rules']
          header_error 'Rules', %/Missing header "Rules"/
        end

        # remove empty line
        @line += 1
        lines.shift if lines.any?

        players = []
        # TODO: validate player index
        headers.select{ |k,v| k.match /^P\d+$/ }.each_pair do |k,v|
          players[k.sub(/^P/, '').to_i - 1] = Player.new v
        end

        rules = @rules_serializer.load headers['Rules']
        game = Game.new rules, players
        rules.setup game

        lines.each do |line|
          m = line.match /^\d+\. [a-z]\:(\d+),(\d+)\-(\d+),(\d+)$/
          raise ParseError, %/Bad action format/ unless m
          origin = game.board.pos m[1].to_i, m[2].to_i
          raise ParseError, %/Unknown position #{m[1]},#{m[2]}/ unless origin
          target = game.board.pos m[3].to_i, m[4].to_i
          raise ParseError, %/Unknown position #{m[3]},#{m[4]}/ unless target
          action = game.current_actions.find{ |a| a.origin == origin and a.target == target }
          raise ParseError, %/Unknown action/ unless action
          game.play action
        end

        game
      end

      private

      def header_error header, msg = nil
        raise HeaderError.new header, @line, msg
      end

      def error *args
        type, msg = ParseError, args.shift
        type, msg = msg, args.shift if msg.kind_of? Class
        raise type.new @line, msg
      end
    end
  end
end
