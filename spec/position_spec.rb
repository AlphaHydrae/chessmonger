
describe 'Position' do

  it "should be initializable with x and y coordinates and an index" do
    lambda{ Chessmonger::Position.new 2, 3, 0 }.should_not raise_error
    lambda{ Chessmonger::Position.new 123, 456, 789 }.should_not raise_error
  end

  it "should not accept coordinates smaller than 1" do
    lambda{ Chessmonger::Position.new 0, 0, 0 }.should raise_error
    lambda{ Chessmonger::Position.new 0, 8, 0 }.should raise_error
    lambda{ Chessmonger::Position.new -1, 8, 0 }.should raise_error
    lambda{ Chessmonger::Position.new 8, -1, 0 }.should raise_error
    lambda{ Chessmonger::Position.new 8, 0, 0 }.should raise_error
    lambda{ Chessmonger::Position.new -2, -3, 0 }.should raise_error
  end

  it "should not accept an index smaller than 0" do
    lambda{ Chessmonger::Position.new 8, 8, -1 }.should raise_error
    lambda{ Chessmonger::Position.new 8, 8, -3 }.should raise_error
  end

  it "should have the specified x and y coordinates" do
    Chessmonger::Position.new(2, 3, 0).tap do |pos|
      pos.x.should == 2
      pos.y.should == 3
    end
  end

  it "should have the specified index" do
    Chessmonger::Position.new(2, 3, 0).tap do |pos|
      pos.index.should == 0
    end
  end

  it "should not accept non-Fixnum arguments" do
    [ nil, false, true, Object.new, [], {}, 'string', :symbol ].each do |invalid|
      lambda{ Chessmonger::Position.new 8, 8, invalid }.should raise_error
      lambda{ Chessmonger::Position.new 8, invalid, 0 }.should raise_error
      lambda{ Chessmonger::Position.new invalid, 8, 0 }.should raise_error
    end
  end
end
