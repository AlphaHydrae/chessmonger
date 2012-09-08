
describe 'Armory' do

  # TODO: check type of behavior when creating

  after :each do
    Chessmonger::Armory.instance.instance_variable_set '@behaviors', {}
  end

  it "should be a singleton" do
    lambda{ Chessmonger::Armory.new }.should raise_error
  end

  it "should be provided as a shorthand by the top module" do
    Chessmonger.armory.should be(Chessmonger::Armory.instance)
  end

  it "should store behaviors by name" do
    behavior = double :create => double
    Chessmonger::Armory.instance.register 'aBehavior', behavior
    Chessmonger::Armory.instance.get('aBehavior').should be(behavior)
  end

  it "should provide the list of registered names" do
    Chessmonger::Armory.instance.names.should be_empty
    b1 = double :create => double
    b2 = double :create => double
    Chessmonger::Armory.instance.register 'aBehavior', b1
    Chessmonger::Armory.instance.register 'anotherBehavior', b2
    Chessmonger::Armory.instance.names.tap do |names|
      names.should have(2).items
      names.should include('aBehavior', 'anotherBehavior')
    end
  end

  it "should replace existing names" do
    b1 = double :create => double
    b2 = double :create => double
    Chessmonger::Armory.instance.register 'aBehavior', b1
    Chessmonger::Armory.instance.register 'aBehavior', b2
    Chessmonger::Armory.instance.get('aBehavior').should be(b2)
  end

  it "should not accept non-behaviors" do
    lambda{ Chessmonger::Armory.instance.register 'aBehavior', Object.new }.should raise_error(ArgumentError)
  end

  it "should train pieces with a new instance of the behavior specified by name" do

    piece = double :player= => nil, :behavior= => nil
    Chessmonger::Piece.stub(:new).and_return piece
    behavior = double
    behavior_factory = double :create => behavior
    game = double
    player = double

    Chessmonger::Armory.instance.register 'aBehavior', behavior_factory

    behavior_factory.should_receive(:create).with game, piece
    Chessmonger::Piece.should_receive :new
    piece.should_receive(:player=).with player
    piece.should_receive(:behavior=).with behavior

    result = Chessmonger::Armory.instance.train 'aBehavior', game, player
    result.should be(piece)
  end
end
