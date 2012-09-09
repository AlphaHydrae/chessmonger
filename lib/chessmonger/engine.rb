dirname = File.dirname __FILE__
libs = File.join dirname, 'engine'
[
  :action, :board, :direction, :game,
  :move, :piece, :player, :position
].each{ |lib| require File.join libs, lib.to_s }
