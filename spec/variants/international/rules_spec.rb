
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
