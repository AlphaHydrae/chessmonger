
describe 'Piece' do

  before :each do

    @player = double :name => 'John Doe'
    @behavior = double :each_action => nil, :can_attack? => false
  end

  it "should be initializable with a behavior" do
    lambda{ Chessmonger::Piece.new @behavior }.should_not raise_error
  end

  it "should be initializable with a behavior and a player" do
    lambda{ Chessmonger::Piece.new @behavior, @player }.should_not raise_error
  end

  it "should have the specified player" do
    piece = Chessmonger::Piece.new @behavior, @player
    piece.player.should be(@player)
  end

  describe 'when used' do

    before :each do

      @game = double
      @origin = double

      @piece = Chessmonger::Piece.new @behavior, @player
    end

    it "should allow its player to be changed" do
      other = double :name => 'Jane Doe'
      @piece.player = other
      @piece.player.should be(other)
    end

    it "should ask its behavior to iterate over the possible actions" do
      block = lambda{}
      @behavior.should_receive(:each_action).with @game, @piece, @origin, &block
      @piece.each_action @game, @origin, &block
    end

    it "should ask its behavior whether it can attack the specified target" do
      target = double
      @behavior.should_receive(:can_attack?).with @game, @piece, @origin, target
      @piece.can_attack? @game, @origin, target
    end
  end
end