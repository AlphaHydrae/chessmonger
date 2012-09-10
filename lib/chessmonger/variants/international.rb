dirname = File.dirname __FILE__
libs = File.join dirname, 'international'
[
  :chess_pawn
].each{ |lib| require File.join libs, lib.to_s }
