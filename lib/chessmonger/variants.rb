dirname = File.dirname __FILE__
libs = File.join dirname, 'variants'
require File.join libs, 'basic'
[
  :international
].each{ |lib| require File.join libs, lib.to_s, 'rules' }
