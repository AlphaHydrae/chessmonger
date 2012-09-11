
# TODO: spec ==
# TODO: store board and simplify directions

describe 'Position' do

  it "should be initializable with x and y coordinates and an index" do
    lambda{ Chessmonger::Position.new 2, 3, 0 }.should_not raise_error
    lambda{ Chessmonger::Position.new 123, 456, 789 }.should_not raise_error
  end

  it "should not accept coordinates smaller than 1" do
    lambda{ Chessmonger::Position.new 0, 0, 0 }.should raise_error(ArgumentError)
    lambda{ Chessmonger::Position.new 0, 8, 0 }.should raise_error(ArgumentError)
    lambda{ Chessmonger::Position.new -1, 8, 0 }.should raise_error(ArgumentError)
    lambda{ Chessmonger::Position.new 8, -1, 0 }.should raise_error(ArgumentError)
    lambda{ Chessmonger::Position.new 8, 0, 0 }.should raise_error(ArgumentError)
    lambda{ Chessmonger::Position.new -2, -3, 0 }.should raise_error(ArgumentError)
  end

  it "should not accept an index smaller than 0" do
    lambda{ Chessmonger::Position.new 8, 8, -1 }.should raise_error(ArgumentError)
    lambda{ Chessmonger::Position.new 8, 8, -3 }.should raise_error(ArgumentError)
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

  describe 'distance' do

    it "should calculate the horizontal distance" do
      index = 0
      a = Chessmonger::Position.new 4, 4, index
      8.times do |i|
        8.times do |j|
          b = Chessmonger::Position.new i + 1, j + 1, index += 1
          a.horizontal_distance(b).should == i - 4 + 1
        end
      end
    end

    it "should calculate the vertical distance" do
      index = 0
      a = Chessmonger::Position.new 4, 4, index
      8.times do |i|
        8.times do |j|
          b = Chessmonger::Position.new i + 1, j + 1, index += 1
          a.vertical_distance(b).should == j - 4 + 1
        end
      end
    end

    it "should calculate the longest distance (horizontal/vertical)" do
      a = Chessmonger::Position.new 4, 4, 0
      b = Chessmonger::Position.new 6, 7, 1
      a.longest_distance(b).should == 3
    end

    it "should calculate the product of distances (horizontal/vertical)" do
      a = Chessmonger::Position.new 4, 4, 0
      b = Chessmonger::Position.new 6, 7, 1
      a.distance_product(b).should == 6
    end
  end
end
