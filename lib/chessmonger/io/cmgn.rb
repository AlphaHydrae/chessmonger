
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

        players = []
        # TODO: validate player index
        headers.select{ |k,v| k.match /^P\d+$/ }.each_pair do |k,v|
          players[k.sub(/^P/, '').to_i - 1] = Player.new v
        end

        rules = Variants::InternationalChess.new
        Game.new rules, players
      end
    end
  end
end
