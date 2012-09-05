
describe "Board" do

  # TODO: check invalid positions
  # TODO: board shallow copy

  describe "positions" do

    it "should be singletons" do

      board = Chessmonger::Board.new 8, 8

      Chessmonger::Position.stub :new
      Chessmonger::Position.should_not_receive :new

      8.times do |x|
        8.times do |y|
          board.pos(x + 1, y + 1).should be(board.pos(x + 1, y + 1))
        end
      end
    end

    it "should all be different" do

      board = Chessmonger::Board.new 8, 8

      positions = []

      8.times do |x|
        8.times do |y|
          pos = board.pos(x + 1, y + 1)
          positions.should_not include(pos)
          positions << pos
        end
      end
    end

    it "should all have different indices" do

      board = Chessmonger::Board.new 8, 8

      indices = []

      8.times do |x|
        8.times do |y|
          pos = board.pos(x + 1, y + 1)
          indices.should_not include(pos.index)
          indices << pos.index
        end
      end
    end
  end

  it "should return each object" do
    board = Chessmonger::Board.new 8, 8
    contents = [
      [ Object.new, board.pos(1, 2) ],
      [ Object.new, board.pos(2, 3) ],
      [ Object.new, board.pos(4, 5) ]
    ]
    contents.each do |op|
      board.put op[0], op[1]
    end
    n = 0
    board.each do |o|
      contents.delete_if{ |op| op[0] === o }
      n += 1
    end
    n.should == 3
    contents.should be_empty
  end

  describe "placement methods" do

    before :each do
      @board = Chessmonger::Board.new 8, 8
      @object = Object.new
      @pos = @board.pos 2, 3
    end

    describe "get" do

      it "should not return anything from an empty board" do
        @board.get(@pos).should be_nil
      end
    end

    describe "put" do

      it "should put objects where specified" do
        @board.put @object, @pos
        @board.get(@pos).should be(@object)
      end

      it "should replace objects where specified" do
        other = Object.new
        @board.put @object, @pos
        @board.put other, @pos
        @board.get(@pos).should be(other)
      end

      it "should return nothing if the position was empty" do
        @board.put(@object, @pos).should be_nil
      end

      it "should return the object that was previously at the position" do
        other = Object.new
        @board.put @object, @pos
        @board.put(other, @pos).should be(@object)
      end
    end

    describe "take" do

      it "should remove objects from the board" do
        @board.put @object, @pos
        @board.take @pos
        @board.get(@pos).should be_nil
      end

      it "should return the object that was previously at the position" do
        @board.put @object, @pos
        @board.take(@pos).should be(@object)
      end
    end

    describe "move" do

      before :each do
        @target = @board.pos 4, 5
      end

      it "should return nothing if the positions were empty" do
        @board.move(@pos, @target).should be_nil
      end

      it "should move objects to the specified target" do
        @board.put @object, @pos
        @board.move @pos, @target
        @board.get(@pos).should be_nil
        @board.get(@target).should be(@object)
      end

      it "should return the object that was previously at the target position" do
        other = Object.new
        @board.put @object, @pos
        @board.put other, @target
        @board.move(@pos, @target).should be(other)
      end
    end
  end

  describe "dimensions" do

    it "should be a width and length" do
      lambda{ Chessmonger::Board.new(8, 8) }.should_not raise_error
    end

    it "should be more than zero" do
      lambda{ Chessmonger::Board.new(0, 8) }.should raise_error
      lambda{ Chessmonger::Board.new(8, 0) }.should raise_error
      lambda{ Chessmonger::Board.new(0, 0) }.should raise_error
      lambda{ Chessmonger::Board.new(-1, 8) }.should raise_error
      lambda{ Chessmonger::Board.new(8, -2) }.should raise_error
      lambda{ Chessmonger::Board.new(-3, -4) }.should raise_error
    end

    it "should be the ones given at construction" do
      board = Chessmonger::Board.new 8, 8
      board.width.should == 8
      board.height.should == 8
    end
  end
end
