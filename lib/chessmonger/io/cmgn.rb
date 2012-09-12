
module Chessmonger

  module IO
    class ParseError < StandardError; end
    class UnsupportedVersionError < ParseError; end

    module CMGN
      VERSION = 1

      def self.save game
        contents = String.new
        contents << "CMGN #{VERSION}"
        game.players.each_with_index{ |p,i| contents << "\nP#{i + 1} #{p.name}" }
        contents << "\n"
        game.history.each do |action|
          # TODO: add action registration
          contents << "\n#{action.origin.x},#{action.origin.y}-#{action.target.x},#{action.target.y}"
        end
        contents
      end

      def self.load contents

        lines = contents.split "\n"

        # check version
        version_line = lines.shift
        unless m = version_line.match(/^CMGN (\d+)/)
          raise ParseError, %/First line must be "CMGN n" where n is the format version number/
        end
        version = m[1].to_i
        raise UnsupportedVersionError, %/CMGN version #{version} is not supported/ unless version == 1

        headers = {}
        while lines.any?
          break unless m = lines.first.match(/^([A-Za-z0-9]+) (.*)$/)
          headers[m[1]] = m[2]
          lines.shift
        end

        raise ParseError, %/Expected a header or an empty line, got "#{lines.first}"/ if lines.any? and lines.first != ''
        lines.shift

        players = []
        # TODO: validate player index
        headers.select{ |k,v| k.match /^P\d+$/ }.each_pair do |k,v|
          players[k.sub(/^P/, '').to_i - 1] = Player.new v
        end

        rules = Variants::InternationalChess.new
        game = Game.new rules, players
        rules.setup game

        lines.each do |line|
          m = line.match /^(\d+),(\d+)\-(\d+),(\d+)$/
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
    end
  end
end
