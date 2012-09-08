
module Chessmonger
  VERSION = '0.0.1'
end

dirname = File.dirname __FILE__
libs = File.join dirname, 'chessmonger'
[
  :action, :armory, :board, :direction, :game,
  :move, :piece, :player, :position
].each{ |lib| require File.join libs, lib.to_s }
