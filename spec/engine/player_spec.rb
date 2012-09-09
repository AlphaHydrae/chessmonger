
describe 'Player' do

  it "should be initializable with a string" do
    lambda{ Chessmonger::Player.new 'John Doe' }.should_not raise_error
  end

  it "should have a name" do
    Chessmonger::Player.new('John Doe').name.should == 'John Doe'
  end
end
