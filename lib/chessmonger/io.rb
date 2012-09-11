dirname = File.dirname __FILE__
libs = File.join dirname, 'io'
[
  :cmgn
].each{ |lib| require File.join libs, lib.to_s }
