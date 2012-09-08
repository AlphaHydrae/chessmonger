
describe 'Game' do

  # TODO: test captures
  # TODO: playing direction proxy

  before :each do

    @rules = double('rules')
    @rules.stub :number_of_players => 2
    @rules.stub :board_width => 8
    @rules.stub :board_height => 8
    @rules.stub :playing_direction => :N
    @rules.stub :pieces => [ 'a', 'b' ]
    @rules.stub :setup
    @rules.stub :allowed? => true
    @rules.stub :actions => []
    @rules.stub :player => double( :name => 'John Doe' )
    @rules.stub :enemy? => true
    
    @players = []

    @p1 = double('p1')
    @p1.stub(:name){ 'John Doe' }
    @players << @p1

    @p2 = double('p2')
    @p2.stub(:name){ 'Jane Doe' }
    @players << @p2

    @p3 = double('p3')
    @p3.stub(:name){ 'John Smith' }

    @board = double('board')
    @board.stub(:width){ 8 }
    @board.stub(:height){ 8 }
    Chessmonger::Board.stub(:new){ @board }
  end

  describe 'when initialized' do

    it "should be ongoing" do
      Chessmonger::Game.new(@rules, @players).status.should be(:ongoing)
    end

    it "should have an empty history" do
      Chessmonger::Game.new(@rules, @players).history.should be_empty
    end

    it "should only accept the number of players defined by the rules" do
      [ [], @players[0, 1], (@players.dup << @p3) ].each do |invalid|
        lambda{ Chessmonger::Game.new(@rules, invalid) }.should raise_error(ArgumentError)
      end
    end

    it "should have the specified players" do
      game = Chessmonger::Game.new @rules, @players
      game.players.should have(2).items
      game.players.should include(@p1, @p2)
    end

    it "should create a board with the dimensions defined by the rules" do
      Chessmonger::Board.should_receive(:new).with(8, 8)
      game = Chessmonger::Game.new @rules, @players
      game.board.should be(@board)
    end

    it "should ask the rules to set up the game" do
      @rules.should_receive(:setup).with kind_of(Chessmonger::Game)
      Chessmonger::Game.new @rules, @players
    end
  end

  describe "as a rules proxy" do

    before :each do
      @game = Chessmonger::Game.new @rules, @players
    end

    it "should ask the rules to return the current player" do
      @rules.should_receive(:player).with @game
      @game.player
    end

    it "should ask the rules to return current actions" do
      @rules.should_receive(:actions).with @game
      @game.actions
    end

    it "should ask the rules whether a piece belongs to an enemy player" do
      piece = double :player => @p2
      @rules.should_receive(:enemy?).with @game, @p1, @p2
      @game.enemy_piece? @p1, piece
    end
  end

  describe '#play' do

    before :each do

      @game = Chessmonger::Game.new @rules, @players

      @action = double('action')
      @action.stub(:play)
      @action.stub(:cancel)
    end

    it "should play the specified action" do
      @action.should_receive(:play).with(@game)
      @game.play @action
    end

    it "should add the action to the game's history" do
      @game.play @action
      @game.history.should have(1).items
      @game.history.should include(@action)
    end
  end

  describe '#cancel' do

    before :each do

      @game = Chessmonger::Game.new @rules, @players

      @a1 = double('action')
      @a1.stub(:play)
      @a1.stub(:cancel)

      @a2 = double('a2')
      @a2.stub(:play)
      @a2.stub(:cancel)

      @game.play @a1
      @game.play @a2
    end

    it "should cancel the last action" do
      @a1.should_not_receive(:cancel)
      @a2.should_receive(:cancel).with(@game)
      @game.cancel
    end

    it "should remove the action from the game's history" do
      @game.history.should have(2).items
      @game.history.should include(@a1, @a2)
      @game.cancel
      @game.history.should have(1).items
      @game.history.should include(@a1)
    end
  end
end
