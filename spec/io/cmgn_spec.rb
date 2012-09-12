
describe 'CMGN' do

  before :each do
    @p1, @p2 = Chessmonger::Player.new('John Doe'), Chessmonger::Player.new('Jane Doe')
    @rules = Chessmonger::Variants::InternationalChess.new
    @game = Chessmonger::Game.new @rules, [ @p1, @p2 ]
    @rules.setup @game
  end

  it "should raise a parse error if the first line has the wrong format" do
    [ 'CMGN', 'CMGN a', 'fubar' ].each do |invalid|
      lambda{ Chessmonger::IO::CMGN.load(invalid) }.should raise_error(Chessmonger::IO::ParseError)
    end
  end

  it "should raise an unsupported version error if the version is unexpected" do
    lambda{ Chessmonger::IO::CMGN.load('CMGN 42') }.should raise_error(Chessmonger::IO::UnsupportedVersionError)
  end

  it "should save and load an empty game correctly" do
    copy = Chessmonger::IO::CMGN.load(Chessmonger::IO::CMGN.save(@game))
    copy.status.should == @game.status
    # FIXME: this should be an equality check on the rules, not on their class
    copy.rules.class.should == @game.rules.class
    copy.players.each_with_index do |p,i|
      @game.players[i].name.should == p.name
    end
    copy.history.length.should == @game.history.length
    copy.history.each_with_index do |action,i|
      original = @game.history[i]
      action.player.name.should == original.player.name
      copy.players.index(action.player).should == @game.players.index(original.player)
      action.origin.should == original.origin
      action.target.should == original.target
    end
  end

  it "should save and load an ongoing game correctly" do
    5.times{ @game.play @game.current_actions.sample }
  end
end
