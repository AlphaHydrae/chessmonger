
module Chessmonger

  module Notations

    class CMGN
      VERSION = 1

      attr_accessor :rules_serializer
      attr_accessor :piece_serializer

      def save game
        check_config!

        contents = String.new
        contents << "CMGN #{VERSION}"
        contents << "\nRules #{@rules_serializer.save(game.rules)}"
        game.players.each_with_index{ |p,i| contents << "\nP#{i + 1} #{p.name}" }
        contents << "\n"

        game.history.each do |action|
          # TODO: add action registration
          player = game.players.index(action.player) + 1
          piece = @piece_serializer.save action.piece, game
          origin = "#{action.origin.x},#{action.origin.y}"
          separator = action.capture ? 'x' : '-'
          target = "#{action.target.x},#{action.target.y}"
          contents << "\n#{player}. #{piece}:#{origin}#{separator}#{target}"
        end

        contents
      end

      def load contents
        check_config!

        if contents.nil?
          error ParseError, "Cannot parse nil"
        end

        lines = contents.split "\n"

        if lines.empty?
          error ParseError, "No contents found"
        end

        # check version
        @line = 1
        version_line = lines.shift
        unless m = version_line.match(/^CMGN (\d+)/)
          error ParseError, %/First line must be "CMGN n" where n is the format version number/
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
            error ParseError, %/Expected a header or an empty line, got "#{lines.first}"/
          end
          headers[m[1]] = m[2]
        end

        if !headers['Rules']
          error HeaderError, %/Missing header "Rules"/, :header => 'Rules'
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
          m = line.match /^\d+\. ([a-z])\:(\d+),(\d+)[x\-](\d+),(\d+)$/
          behavior_letter = m[1]
          ox, oy, tx, ty = m[2], m[3], m[4], m[5]
          error ParseError, %/Bad action format/ unless m
          origin = game.board.pos ox.to_i, oy.to_i
          error ParseError, %/Unknown position #{ox},#{oy}/ unless origin
          target = game.board.pos tx.to_i, ty.to_i
          error ParseError, %/Unknown position #{tx},#{ty}/ unless target
          action = game.current_actions.find do |a|
            a.origin == origin and a.target == target
          end
          error ParseError, %/Unknown action #{line}/ unless action
          error ParseError, %/Unknown piece #{behavior_letter}/ unless @piece_serializer.match? action.piece, behavior_letter, game
          game.play action
        end

        game
      end

      private

      def check_config!
        if !@rules_serializer
          config_error 'No rules serializer has been set', :rules_serializer
        elsif !@piece_serializer
          config_error 'No piece serializer has been set', :piece_serializer
        end
      end

      def config_error msg, config
        raise ConfigError.new(msg).tap{ |e| e.config = config }
      end

      def error type, msg, options = {}
        e = type.new msg
        { :line => @line }.merge(options).each_pair do |k,v|
          e.send "#{k}=", v
        end
        raise e
      end
    end
  end
end
