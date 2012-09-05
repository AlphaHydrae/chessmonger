
describe 'Direction' do

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

  it "should provide all cardinal directions" do
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
    
    it "should work for N" do
      target = @board.pos 4, 6
      Chessmonger::Direction.between(@pos, target).should be(Chessmonger::Direction::N)
    end
    
    it "should work for NE" do
      target = @board.pos 6, 6
      Chessmonger::Direction.between(@pos, target).should be(Chessmonger::Direction::NE)
    end
    
    it "should work for E" do
      target = @board.pos 6, 4
      Chessmonger::Direction.between(@pos, target).should be(Chessmonger::Direction::E)
    end
    
    it "should work for SE" do
      target = @board.pos 6, 2
      Chessmonger::Direction.between(@pos, target).should be(Chessmonger::Direction::SE)
    end
    
    it "should work for S" do
      target = @board.pos 4, 2
      Chessmonger::Direction.between(@pos, target).should be(Chessmonger::Direction::S)
    end
    
    it "should work for SW" do
      target = @board.pos 2, 2
      Chessmonger::Direction.between(@pos, target).should be(Chessmonger::Direction::SW)
    end
    
    it "should work for W" do
      target = @board.pos 2, 4
      Chessmonger::Direction.between(@pos, target).should be(Chessmonger::Direction::W)
    end
    
    it "should work for NW" do
      target = @board.pos 2, 6
      Chessmonger::Direction.between(@pos, target).should be(Chessmonger::Direction::NW)
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

    it 'N should go north' do
      Chessmonger::Direction::N.from(@board, @pos).tap do |pos|
        pos.x.should == 4
        pos.y.should == 5
      end
    end

    it 'NE should go north-east' do
      Chessmonger::Direction::NE.from(@board, @pos).tap do |pos|
        pos.x.should == 5
        pos.y.should == 5
      end
    end

    it 'E should go east' do
      Chessmonger::Direction::E.from(@board, @pos).tap do |pos|
        pos.x.should == 5
        pos.y.should == 4
      end
    end

    it 'SE should go south-east' do
      Chessmonger::Direction::SE.from(@board, @pos).tap do |pos|
        pos.x.should == 5
        pos.y.should == 3
      end
    end

    it 'S should go south' do
      Chessmonger::Direction::S.from(@board, @pos).tap do |pos|
        pos.x.should == 4
        pos.y.should == 3
      end
    end

    it 'SW should go south-west' do
      Chessmonger::Direction::SW.from(@board, @pos).tap do |pos|
        pos.x.should == 3
        pos.y.should == 3
      end
    end

    it 'W should go west' do
      Chessmonger::Direction::W.from(@board, @pos).tap do |pos|
        pos.x.should == 3
        pos.y.should == 4
      end
    end

    it 'NW should go north-west' do
      Chessmonger::Direction::NW.from(@board, @pos).tap do |pos|
        pos.x.should == 3
        pos.y.should == 5
      end
    end
  end
end
