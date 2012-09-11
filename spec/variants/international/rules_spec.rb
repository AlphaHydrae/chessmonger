
describe 'InternationalChess' do
  extend RulesSpecGenerator

  before :each do
    @p1, @p2 = Chessmonger::Player.new('John Doe'), Chessmonger::Player.new('Jane Doe')
    @rules = Chessmonger::Variants::InternationalChess.new
    @game = Chessmonger::Game.new @rules, [ @p1, @p2 ]
  end

  its_board_dimensions_should_be 8, 8
  its_number_of_players_should_be 2
  its_players_should_be_enemies
  its_players_should_play_in_turn
  its_two_players_should_move_north_and_south

  it "should set up the pieces correctly" do

    @rules.setup @game
    board = @game.board

    # rank 1
    #8.times{ |i| board.get(board.pos(i + 1, 1)).player.should be(@game.players[0]) }
    board.get(board.pos(5, 1)).behavior.should be_a_kind_of(Chessmonger::Behavior::ChessKing)

    # pawns on rank 2
    8.times do |i|
      pos = @game.board.pos i + 1, 2
      @game.board.get(pos).tap do |piece|
        piece.player.should be(@game.players[0])
        piece.behavior.should be_a_kind_of(Chessmonger::Behavior::ChessPawn)
      end
    end

    # nothing on ranks 3 through 6
    4.times do |i|
      8.times do |j|
        pos = @game.board.pos j + 1, i + 3
        @game.board.get(pos).should be_nil
        @game.board.get(pos).should be_nil
      end
    end

    # pawns on rank 7
    8.times do |i|
      pos = @game.board.pos i + 1, 7
      @game.board.get(pos).tap do |piece|
        piece.player.should be(@game.players[1])
        piece.behavior.should be_a_kind_of(Chessmonger::Behavior::ChessPawn)
      end
    end

    # rank 8
    #8.times{ |i| board.get(board.pos(i + 1, 1)).player.should be(@game.players[1]) }
    board.get(board.pos(4, 8)).behavior.should be_a_kind_of(Chessmonger::Behavior::ChessKing)
  end
end
