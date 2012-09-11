
describe 'InternationalChess' do

  before :each do
    @p1, @p2 = Chessmonger::Player.new('John Doe'), Chessmonger::Player.new('Jane Doe')
    @rules = Chessmonger::Variants::InternationalChess.new
    @game = Chessmonger::Game.new @rules, [ @p1, @p2 ]
  end

  it "should have a board of 8x8" do
    @rules.board_width.should == 8
    @rules.board_height.should == 8
  end

  it "should have 2 players" do
    @rules.number_of_players.should == 2
  end

  it "should return north as the playing direction of the first player" do
    @rules.playing_direction(@game, @p1).should == Chessmonger::Direction::N
  end

  it "should return south as the playing direction of the second player" do
    @rules.playing_direction(@game, @p2).should == Chessmonger::Direction::S
  end

  it "should return the first player as the current player for a new game" do
    @rules.current_player(@game).should be(@p1)
  end

  it "should return the second player as the current player after a move from the first player" do
    move = Chessmonger::Move.new @p1, double, @game.board.pos(4, 2), @game.board.pos(4, 3)
    @game.play move
    @rules.current_player(@game).should be(@p2)
  end

  it "should indicate both players as mutual enemies" do
    @rules.enemy?(@game, @p1, @p2).should be_true
    @rules.enemy?(@game, @p2, @p1).should be_true
    @rules.enemy?(@game, @p1, @p1).should be_false
    @rules.enemy?(@game, @p2, @p2).should be_false
  end

  describe '#setup' do

    before :each do
      @rules.setup @game
    end

    it "should put nothing on ranks 3 through 6" do
      4.times do |i|
        8.times do |j|
          pos = @game.board.pos j + 1, i + 3
          @game.board.get(pos).should be_nil
          @game.board.get(pos).should be_nil
        end
      end
    end

    it "should put player 1 pawns on rank 2" do
      8.times do |i|
        pos = @game.board.pos i + 1, 2
        @game.board.get(pos).tap do |piece|
          piece.player.should be(@game.players[0])
          piece.behavior.should be_a_kind_of(Chessmonger::Behavior::ChessPawn)
        end
      end
    end

    it "should put player 2 pawns on rank 7" do
      8.times do |i|
        pos = @game.board.pos i + 1, 7
        @game.board.get(pos).tap do |piece|
          piece.player.should be(@game.players[1])
          piece.behavior.should be_a_kind_of(Chessmonger::Behavior::ChessPawn)
        end
      end
    end
  end
end
