require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'simplecov'
SimpleCov.start

require 'rspec'
require 'chessmonger'

module RulesSpecGenerator

  def its_board_dimensions_should_be width, height
    it "should have a board of #{width}x#{height}" do
      @rules.board_width.should == width
      @rules.board_height.should == height
    end
  end

  def its_number_of_players_should_be n
    it "should have #{n} players" do
      @rules.number_of_players.should == n
    end
  end

  def its_players_should_be_enemies
    it "should indicate all players as mutual enemies" do
      @game.players.each do |p1|
        @game.players.each do |p2|
          @rules.enemy?(@game, p1, p2).should == (p1 != p2)
        end
      end
    end
  end

  def its_players_should_play_in_turn
    it "should make each player play in turn" do
      @rules.current_player(@game).should be(@game.players[0])
      @game.players.each do |p|
        i = @game.players.index(p) + 1
        i = 0 if i >= @game.players.length
        current = @game.players[i]
        move = Chessmonger::Move.new p, double, @game.board.pos(1, 1), @game.board.pos(2, 2)
        @game.play move
        @rules.current_player(@game).should be(current)
      end
    end
  end

  def its_two_players_should_move_north_and_south
    it "should return north as the playing direction of the first player" do
      @rules.playing_direction(@game, @game.players[0]).should == Chessmonger::Direction::N
    end

    it "should return south as the playing direction of the second player" do
      @rules.playing_direction(@game, @game.players[1]).should == Chessmonger::Direction::S
    end
  end
end
