
describe 'Chess King' do

  before :each do

    @rules = double
    @rules.stub :board_width => 8
    @rules.stub :board_height => 8
    @rules.stub :number_of_players => 2
    @rules.stub :playing_direction => Chessmonger::Direction::N
    @rules.stub(:enemy?){ |player,other| player != other }

    @p1 = Chessmonger::Player.new 'John Doe'
    @p2 = Chessmonger::Player.new 'Jane Doe'
    @game = Chessmonger::Game.new @rules, [ @p1, @p2 ]

    @behavior = Chessmonger::Variants::InternationalChess::King.new
    @king = Chessmonger::Piece.new
    @king.player = @p1
    @king.behavior = @behavior
  end

  it "should be able to attack all around" do
    
    origin = @game.board.pos 4, 4
    @game.board.put @king, origin

    targets = Chessmonger::Direction::ALL.collect{ |dir| dir.from @game.board, origin }

    8.times do |i|
      8.times do |j|
        target = @game.board.pos i + 1, j + 1
        next if target == origin
        @king.can_attack?(@game, origin, target).should == targets.include?(target)
      end
    end
  end

  it "should move one square in any direction" do

    origin = @game.board.pos 4, 4
    @game.board.put @king, origin

    targets = Chessmonger::Direction::ALL.collect do |dir|
      dir.from @game.board, origin
    end

    actions = @king.actions @game, origin
    actions.should have(8).items
    actions.collect{ |a| a.target }.should include(*targets)
  end

  it "should attack one square in any direction" do

    origin = @game.board.pos 4, 4
    @game.board.put @king, origin

    enemy_pieces = []
    targets = []

    # put 5 pieces around the king
    [ :N, :NE, :E, :SW, :W ].each do |dir_name|
      dir = Chessmonger::Direction.const_get dir_name
      enemy_pieces << piece = double(:player => @p2)
      targets << target = dir.from(@game.board, origin)
      @game.board.put piece, target
    end

    # put 3 pieces elsewhere
    @game.board.put double(:player => @p2), @game.board.pos(4, 6)
    @game.board.put double(:player => @p2), @game.board.pos(6, 2)
    @game.board.put double(:player => @p2), @game.board.pos(2, 5)

    actions = @king.actions @game, origin
    actions.should have(8).items
    actions.select{ |a| a.capture.nil? }.should have(3).items
    actions.select{ |a| a.capture }.tap do |captures|
      captures.should have(5).items
      captures.collect{ |c| c.target }.should include(*targets)
      captures.collect{ |c| c.capture }.should include(*enemy_pieces)
    end
  end
end
