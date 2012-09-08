
module Chessmonger
  VERSION = '0.0.2'
end

dirname = File.dirname __FILE__
libs = File.join dirname, 'chessmonger'
[
  :action, :armory, :board, :direction, :distance, :game,
  :move, :piece, :player, :position, :rules
].each{ |lib| require File.join libs, lib.to_s }
