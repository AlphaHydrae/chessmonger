
describe 'Action' do

  before :each do

    @player = double('player')
    @player.stub(:name){ 'John Doe' }
    @player.stub(:kind_of?){ |type| type == Chessmonger::Player }

    @game = double('game')
  end

  it "should be initializable with a player" do
    lambda{ Chessmonger::Action.new @player }.should_not raise_error
  end

  it "should have the specified player" do
    Chessmonger::Action.new(@player).player.should be(@player)
  end

  it "should only accept a player as argument" do
    [ nil, false, true, Object.new, [], {}, '', :symbol, -2, 0, 3, 4.5 ].each do |invalid|
      lambda{ Chessmonger::Action.new invalid }.should raise_error
    end
  end

  it "should not be playable" do
    lambda{ Chessmonger::Action.new(@player).play @game }.should raise_error
  end

  it "should not be cancelable" do
    lambda{ Chessmonger::Action.new(@player).cancel @game }.should raise_error
  end
end
