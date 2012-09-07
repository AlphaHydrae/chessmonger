
describe 'Move' do

  before :each do

    @board = double
    @board.stub :move

    @p1 = double :name => 'John Doe'
    @p2 = double :name => 'Jane Doe'

    @captures = {
      @p1 => @p1_captures = double,
      @p2 => @p2_captures = double
    }
    
    @game = double
    @game.stub :board => @board
    @game.stub :captures => @captures

    @piece = double
    @origin = double
    @target = double
    @capture = double
  end

  it "should be initializable with a player, piece, origin and target" do
    lambda{ Chessmonger::Move.new @p1, @piece, @origin, @target }.should_not raise_error
  end

  it "should be initializable with an additional captured piece" do
    lambda{ Chessmonger::Move.new @p2, @piece, @origin, @target, @capture }.should_not raise_error
  end

  it "should provide access to its arguments" do
    move = Chessmonger::Move.new @p1, @piece, @origin, @target, @capture
    move.should respond_to(:player)
    move.should respond_to(:piece)
    move.should respond_to(:origin)
    move.should respond_to(:target)
    move.should respond_to(:capture)
  end

  describe 'without a capture' do

    before :each do
      @move = Chessmonger::Move.new @p2, @piece, @origin, @target
    end

    it "should ask the board to move the piece when played" do
      @board.should_receive(:move).with @origin, @target
      @move.play @game
    end

    it "should ask the board to move the piece back when canceled" do
      @board.should_receive(:move).with @target, @origin
      @move.cancel @game
    end
  end

  describe 'with a capture' do

    before :each do
      @move = Chessmonger::Move.new @p1, @piece, @origin, @target, @capture
    end

    it "should ask the board to move the piece and add its capture to the game when played" do
      @board.should_receive(:move).with @origin, @target
      @p1_captures.should_receive(:<<).with @capture
      @move.play @game
    end

    it "should ask the board to move the piece back and put the capture back when canceled" do
      @board.should_receive(:move).with @target, @origin
      @p1_captures.should_receive(:delete).with @capture
      @board.should_receive(:put).with @capture, @target
      @move.cancel @game
    end
  end
end
