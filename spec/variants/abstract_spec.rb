
describe 'Abstract Rules' do
  extend RulesSpecGenerator

  before :each do
    @p1, @p2 = Chessmonger::Player.new('John Doe'), Chessmonger::Player.new('Jane Doe')
    @rules = Chessmonger::Variants::BasicRules.new
    @game = Chessmonger::Game.new @rules, [ @p1, @p2 ]
  end

  its_board_dimensions_should_be 8, 8
  its_number_of_players_should_be 2
  its_players_should_be_enemies
  its_players_should_play_in_turn
  its_two_players_should_move_north_and_south

  it "should raise an error when trying to set up the game" do
    lambda{ @rules.setup @game }.should raise_error(NotImplementedError)
  end

  it "should raise an error when trying to determine whether the current situation is allowed" do
    lambda{ @rules.allowed? @game, @p1 }.should raise_error(NotImplementedError)
  end

  it "should ask pieces for their actions and try them" do

    @rules.stub :allowed? => true

    @a1 = double :play => nil, :cancel => nil
    @a2 = double :play => nil, :cancel => nil
    @a3 = double :play => nil, :cancel => nil
    @a4 = double :play => nil, :cancel => nil

    @b1 = double
    @b1.stub(:each_action).and_yield(@a1).and_yield(@a2)
    @game.board.put Chessmonger::Piece.new(@b1, @p1), @game.board.pos(4, 2)

    @b2 = double
    @b2.stub(:each_action).and_yield(@a3)
    @game.board.put Chessmonger::Piece.new(@b2, @p2), @game.board.pos(7, 7)

    @b3 = double
    @b3.stub(:each_action).and_yield(@a4)
    @game.board.put Chessmonger::Piece.new(@b3, @p1), @game.board.pos(1, 1)

    @b1.should_receive :each_action
    @b2.should_not_receive :each_action
    @b3.should_receive :each_action

    @a1.should_receive :play
    @a1.should_receive :cancel
    @a2.should_receive :play
    @a2.should_receive :cancel
    @a3.should_not_receive :play
    @a3.should_not_receive :cancel
    @a4.should_receive :play
    @a4.should_receive :cancel

    @rules.should_receive(:allowed?).exactly(3).times

    actions = @rules.current_actions @game
    actions.should have(3).items
    actions.should include(@a1, @a2, @a4)
  end
end
