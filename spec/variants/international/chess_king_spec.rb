
describe 'Chess King' do

  before :each do

    @rules = double
    @rules.stub :board_width => 8
    @rules.stub :board_height => 8
    @rules.stub :number_of_players => 2
    @rules.stub :playing_direction => Chessmonger::Direction::N
    @rules.stub :enemy? => true

    @p1 = Chessmonger::Player.new 'John Doe'
    @p2 = Chessmonger::Player.new 'Jane Doe'
    @game = Chessmonger::Game.new @rules, [ @p1, @p2 ]

    @behavior = Chessmonger::Behavior::ChessKing.new
    @king = Chessmonger::Piece.new
    @king.player = @p1
    @king.behavior = @behavior
  end

  it "should attack all around" do
    
    origin = @game.board.pos 4, 4
    @game.board.put @king, origin
    
    Chessmonger::Direction::ALL.each do |dir|
      target = dir.from @game.board, origin
      @king.can_attack?(@game, origin, target).should be_true
    end
  end

  it "should be able to move one square in any direction" do

    origin = @game.board.pos 4, 4
    @game.board.put @king, origin

    targets = Chessmonger::Direction::ALL.collect do |dir|
      dir.from @game.board, origin
    end

    actions = @king.actions @game, origin
    actions.should have(8).items
    actions.collect{ |a| a.target }.should include(*targets)
  end
end
