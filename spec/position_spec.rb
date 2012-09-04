
describe 'Position' do

  # TODO: check that coordinates are Fixnum

  it "should be initializable with x and y coordinates" do
    lambda{ Chessmonger::Position.new 2, 3 }.should_not raise_error
    lambda{ Chessmonger::Position.new 123, 456 }.should_not raise_error
    lambda{ Chessmonger::Position.new 0, 0 }.should_not raise_error
    lambda{ Chessmonger::Position.new -1, 8 }.should_not raise_error
    lambda{ Chessmonger::Position.new -2, -4 }.should_not raise_error
  end

  it "should have the specified x and y coordinates" do
    Chessmonger::Position.new(2, 3).tap do |pos|
      pos.x.should == 2
      pos.y.should == 3
    end
  end
end
