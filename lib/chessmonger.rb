
module Chessmonger
  VERSION = '0.0.2'
end

dirname = File.dirname __FILE__
libs = File.join dirname, 'chessmonger'
[
  :core, :engine, :io, :variants
].each{ |lib| require File.join libs, lib.to_s }
