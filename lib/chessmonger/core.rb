dirname = File.dirname __FILE__
libs = File.join dirname, 'core'
[
  :armory, :rules
].each{ |lib| require File.join libs, lib.to_s }
