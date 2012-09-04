require 'helper'

describe 'Version' do

  it "should be correct" do
    version_file = File.open(File.join(File.dirname(__FILE__), '..', 'VERSION'), 'r')
    Chessmonger::VERSION.should == version_file.read
  end
end
