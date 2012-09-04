
describe "Board" do

  it "should return each object" do
    board = Chessmonger::Board.new 8, 8
    contents = [
      [ Object.new, Chessmonger::Position.new(1, 2) ],
      [ Object.new, Chessmonger::Position.new(2, 3) ],
      [ Object.new, Chessmonger::Position.new(4, 5) ]
    ]
    contents.each do |op|
      board.put op[0], op[1]
    end
    n = 0
    board.each do |o|
      contents.delete contents.select{ |op| op[0] === o }
      n += 1
    end
    n.should == 3
    contents.should be_empty
  end

  describe "placement method" do

    before :each do
      @board = Chessmonger::Board.new
      @object = Object.new
      @pos = Chessmonger::Position.new 2, 3
    end

    describe "#get" do

      it "should not return anything from an empty board" do
        @board.get(@pos).should be_nil
      end
    end

    describe "#put" do

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

    describe "#take" do

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

    describe "#move" do

      before :each do
        @target = Chessmonger::Position.new 4, 5
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
  end
end
