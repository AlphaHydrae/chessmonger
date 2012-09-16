
describe 'Chess Pawn' do

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

    @behavior = Chessmonger::Variants::InternationalChess::Pawn.new
    @pawn = Chessmonger::Piece.new
    @pawn.player = @p1
    @pawn.behavior = @behavior
  end

  it "should attack diagonally" do

    origin = @game.board.pos 4, 4
    @game.board.put @pawn, origin
    dir = @game.playing_direction @pawn.player

    left_target = dir.rotate(-1).from @game.board, origin
    right_target = dir.rotate(1).from @game.board, origin
    correct_targets = [ left_target, right_target ]

    8.times do |i|
      8.times do |j|
        target = @game.board.pos i + 1, j + 1
        @pawn.can_attack?(@game, origin, target).should == correct_targets.include?(target)
      end
    end
  end

  it "should move forward one square" do
    5.times do |y|

      # testing from 4,3 to 4,7
      origin = @game.board.pos 4, y + 3
      dir = @game.playing_direction @pawn.player
      target = dir.from @game.board, origin

      actions = @pawn.actions @game, origin
      actions.should have(1).items
      actions.first.origin.should == origin
      actions.first.target.should == target
      actions.first.capture.should be_nil
    end
  end

  it "should not be able to move forward if a piece is blocking the way" do

    origin = @game.board.pos 4, 4
    dir = @game.playing_direction @pawn.player
    target = dir.from @game.board, origin

    blocking = double
    @game.board.put blocking, target

    actions = @pawn.actions @game, origin
    actions.should be_empty
  end

  it "should be able to attack diagonally" do
    
    origin = @game.board.pos 4, 4
    dir = @game.playing_direction @pawn.player

    right_target = dir.rotate(1).from @game.board, origin
    right_piece = double :player => @p2
    @game.board.put right_piece, right_target

    left_target = dir.rotate(-1).from @game.board, origin
    left_piece = double :player => @p2
    @game.board.put left_piece, left_target

    front_target = dir.from @game.board, origin
    front_piece = double :player => @p1
    @game.board.put front_piece, front_target

    actions = @pawn.actions @game, origin
    actions.should have(2).items

    a1 = actions.find{ |a| a.target == right_target }
    a1.origin.should == origin
    a1.capture.should == right_piece

    a2 = actions.find{ |a| a.target == left_target }
    a2.origin.should == origin
    a2.capture.should == left_piece
  end
end
