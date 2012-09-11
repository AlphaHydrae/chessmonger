
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

  it "should ask each piece of the current player for its actions" do

    @b1 = double
    @b1.stub(:each_action).and_yield('a').and_yield('b')
    @game.board.put Chessmonger::Piece.new(@b1, @p1), @game.board.pos(4, 2)

    @b2 = double
    @b2.stub(:each_action).and_yield('c')
    @game.board.put Chessmonger::Piece.new(@b2, @p2), @game.board.pos(7, 7)

    @b3 = double
    @b3.stub(:each_action).and_yield('d')
    @game.board.put Chessmonger::Piece.new(@b3, @p1), @game.board.pos(1, 1)

    @b1.should_receive :each_action
    @b2.should_not_receive :each_action
    @b3.should_receive :each_action

    actions = @rules.current_actions @game
    actions.should have(3).items
    actions.should include('a', 'b', 'd')
  end
end
