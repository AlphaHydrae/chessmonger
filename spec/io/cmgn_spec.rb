
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
    # FIXME: this should be an equality check on the rules, not on their class
    copy.rules.class.should == @game.rules.class
    copy.players.each_with_index do |p,i|
      @game.players[i].name.should == p.name
    end
  end
end
