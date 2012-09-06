
describe 'Direction' do

  # TODO: check that #from does not run out of the board

  it "should be initializable with two integer differentials" do
    lambda{ Chessmonger::Direction.new 4, 4 }.should_not raise_error
    lambda{ Chessmonger::Direction.new 4, -4 }.should_not raise_error
    lambda{ Chessmonger::Direction.new -4, -4 }.should_not raise_error
    lambda{ Chessmonger::Direction.new -4, 4 }.should_not raise_error
    lambda{ Chessmonger::Direction.new 0, 0 }.should_not raise_error
  end

  it "should not accept non-integer arguments" do
    [ nil, false, true, Object.new, [], {}, 'string', :symbol ].each do |invalid|
      lambda{ Chessmonger::Direction.new invalid, 4 }.should raise_error
      lambda{ Chessmonger::Direction.new 4, invalid }.should raise_error
    end
  end

  it "should provide the cardinal directions" do
    Chessmonger::Direction::ALL.should == [
      Chessmonger::Direction::N, Chessmonger::Direction::NE,
      Chessmonger::Direction::E, Chessmonger::Direction::SE,
      Chessmonger::Direction::S, Chessmonger::Direction::SW,
      Chessmonger::Direction::W, Chessmonger::Direction::NW
    ]
  end

  it "should provide the horizontal directions" do
    Chessmonger::Direction::HORIZONTAL.should == [ Chessmonger::Direction::E, Chessmonger::Direction::W ]
  end

  it "should provide the vertical directions" do
    Chessmonger::Direction::VERTICAL.should == [ Chessmonger::Direction::N, Chessmonger::Direction::S ]
  end

  it "should provide the straight directions" do
    Chessmonger::Direction::STRAIGHT.should == [
      Chessmonger::Direction::N, Chessmonger::Direction::E,
      Chessmonger::Direction::S, Chessmonger::Direction::W
    ]
  end

  it "should provide the diagonal directions" do
    Chessmonger::Direction::DIAGONAL.should == [
      Chessmonger::Direction::NE, Chessmonger::Direction::SE,
      Chessmonger::Direction::SW, Chessmonger::Direction::NW
    ]
  end

  it "should provide all cardinal directions as constants" do
    [ :N, :NE, :E, :SE, :S, :SW, :W, :NW ].each do |dir|
      Chessmonger::Direction.const_defined?(dir.to_s).should be_true
      Chessmonger::Direction.const_get(dir.to_s).should be_a_kind_of(Chessmonger::Direction)
    end
  end

  describe '::between' do

    before :each do
      @board = Chessmonger::Board.new 8, 8
      @pos = @board.pos 4, 4
    end

    [
      [ 4, 6, :N ], [ 6, 6, :NE ], [ 6, 4, :E ], [ 6, 2, :SE ],
      [ 4, 2, :S ], [ 2, 2, :SW ], [ 2, 4, :W ], [ 2, 6, :NW ]
    ].each do |test|
      
      x, y = test[0], test[1]
      expected_direction = test[2]

      it "should work for #{expected_direction}" do
        target = @board.pos x, y
        direction = Chessmonger::Direction.const_get expected_direction.to_s
        Chessmonger::Direction.between(@pos, target).should be(direction)
      end
    end
  end

  describe '::smallest_angle_between' do
    
    dirs = [ :N, :NE, :E, :SE, :S, :SW, :W, :NW ]

    (1..8).each do |n45|

      it "should work for #{n45} * 45 degrees" do
        
        8.times do |i|
          dir1 = Chessmonger::Direction.const_get dirs[i].to_s
          i2 = i + n45
          i2 -= 8 if i2 > 7
          dir2 = Chessmonger::Direction.const_get dirs[i2].to_s
          expected_angle = n45 > 4 ? 8 - n45 : n45
          Chessmonger::Direction.smallest_angle_between(dir1, dir2).should == expected_angle
        end
      end
    end
  end

  describe '#from' do
    
    before :each do
      @board = Chessmonger::Board.new 8, 8
      @pos = @board.pos 4, 4
    end

    it "should move by the specified differential" do
      Chessmonger::Direction.new(2, 3).from(@board, @pos).tap do |pos|
        pos.x.should == 6
        pos.y.should == 7
      end
    end

    it "should move the specified distance" do
      Chessmonger::Direction.new(1, -1).from(@board, @pos, 2).tap do |pos|
        pos.x.should == 6
        pos.y.should == 2
      end
    end
  end

  describe '#rotate' do

    it "should rotate 45 degrees by default" do
      dirs = [ :N, :NE, :E, :SE, :S, :SW, :W, :NW ]
      dirs.each do |dir|
        original = dirs.index dir
        target = original == 7 ? dirs.first : dirs[original + 1]
        expected = Chessmonger::Direction.const_get target.to_s
        Chessmonger::Direction.const_get(dir.to_s).rotate.should be(expected)
      end
    end

    it "should not work for non-cardinal directions" do
      [ [ 0, 0 ], [ 1, 1 ], [ -1, 0 ], [ 1, 2 ], [ 2, 3 ], [ -4, 8 ], [ 3, -5 ], [ 8, 8 ] ].each do |invalid|
        Chessmonger::Direction.new(invalid[0], invalid[1]).rotate.should be_nil
      end
    end
  end

  describe 'cardinals' do

    before :each do
      @board = Chessmonger::Board.new 8, 8
      @pos = @board.pos 4, 4
    end

    [
      [ :N, 4, 5 ], [ :NE, 5, 5 ], [ :E, 5, 4 ], [ :SE, 5, 3 ],
      [ :S, 4, 3 ], [ :SW, 3, 3 ], [ :W, 3, 4 ], [ :NW, 3, 5 ]
    ].each do |test|

      direction_name = test[0]
      expected_x = test[1]
      expected_y = test[2]

      it "#{direction_name} should go in the correct direction" do
        Chessmonger::Direction.const_get(direction_name.to_s).from(@board, @pos).tap do |pos|
          pos.x.should == expected_x
          pos.y.should == expected_y
        end
      end
    end
  end
end
