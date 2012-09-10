
describe 'Piece' do

  it "should be initializable with nothing" do
    game = double
    lambda{ Chessmonger::Piece.new }.should_not raise_error
  end

  describe 'when used' do

    before :each do

      @game = double
      @player = double :name => 'John Doe'
      @game = double
      @behavior = double :each_action => nil, :can_attack? => false
      @origin = double

      @piece = Chessmonger::Piece.new
    end

    it "should allow its behavior to be set" do
      @piece.behavior = @behavior
      @piece.behavior.should be(@behavior)
    end

    it "should allow its player to be set" do
      @piece.player = @player
      @piece.player.should be(@player)
    end

    it "should ask its behavior to iterate over the possible actions" do
      @piece.behavior = @behavior
      block = lambda{}
      @behavior.should_receive(:each_action).with @game, @piece, @origin, &block
      @piece.each_action @game, @origin, &block
    end

    it "should return all actions given by its behavior" do
      behavior = double
      behavior.stub(:each_action).and_yield('a').and_yield('b')
      @piece.behavior = behavior
      @piece.actions(@game, @origin).should == [ 'a', 'b' ]
    end

    it "should ask its behavior whether it can attack the specified target" do
      @piece.behavior = @behavior
      target = double
      @behavior.should_receive(:can_attack?).with @game, @piece, @origin, target
      @piece.can_attack? @game, @origin, target
    end
  end
end
