
describe 'Player' do

  it "should be initializable with a string" do
    lambda{ Chessmonger::Player.new 'John Doe' }.should_not raise_error
  end

  it "should have a name" do
    Chessmonger::Player.new('John Doe').name.should == 'John Doe'
  end

  it "should only accept a string as argument" do
    [ nil, false, true, Object.new, [], {}, :symbol, -2, 0, 3, 4.5 ].each do |invalid|
      lambda{ Chessmonger::Player.new invalid }.should raise_error
    end
  end

  it "should not accept empty strings as argument" do
    [ '', ' ', "\t", "\n" ].each do |invalid|
      lambda{ Chessmonger::Player.new invalid }.should raise_error
    end
  end
end
