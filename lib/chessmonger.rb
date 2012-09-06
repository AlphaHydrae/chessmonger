
module Chessmonger
  VERSION = '0.0.1'
end

dirname = File.dirname __FILE__
libs = File.join dirname, 'chessmonger'
[ :board, :direction, :game, :player, :position ].each{ |lib| require File.join libs, lib.to_s }
