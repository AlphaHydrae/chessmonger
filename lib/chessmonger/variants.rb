dirname = File.dirname __FILE__
libs = File.join dirname, 'variants'
[
  :international
].each{ |lib| require File.join libs, lib.to_s }
