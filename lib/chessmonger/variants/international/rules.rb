dirname = File.dirname __FILE__
[
  :chess_pawn
].each{ |lib| require File.join dirname, lib.to_s }
