
describe 'Action' do

  before :each do

    @player = double('player')
    @player.stub(:name){ 'John Doe' }

    @game = double('game')
  end

  it "should be initializable with a player" do
    lambda{ Chessmonger::Action.new @player }.should_not raise_error
  end

  it "should have the specified player" do
    Chessmonger::Action.new(@player).player.should be(@player)
  end

  it "should not be playable" do
    lambda{ Chessmonger::Action.new(@player).play @game }.should raise_error
  end

  it "should not be cancelable" do
    lambda{ Chessmonger::Action.new(@player).cancel @game }.should raise_error
  end
end
