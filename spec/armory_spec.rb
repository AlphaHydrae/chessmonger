
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

  it "should store behaviors by their name" do
    name = 'aBehavior'
    behavior = double :create => double, :name => name
    Chessmonger::Armory.instance.register behavior
    Chessmonger::Armory.instance.get(name).should be(behavior)
  end

  it "should allow to override the name" do
    behavior = double :create => double, :name => 'aBehavior'
    name = 'anotherName'
    Chessmonger::Armory.instance.register behavior, :name => name
    Chessmonger::Armory.instance.get('aBehavior').should be_nil
    Chessmonger::Armory.instance.get(name).should be(behavior)
  end

  it "should provide the list of registered names" do
    Chessmonger::Armory.instance.names.should be_empty
    b1 = double :create => double, :name => 'aBehavior'
    b2 = double :create => double, :name => 'anotherBehavior'
    Chessmonger::Armory.instance.register b1
    Chessmonger::Armory.instance.register b2
    Chessmonger::Armory.instance.names.tap do |names|
      names.should have(2).items
      names.should include('aBehavior', 'anotherBehavior')
    end
  end

  it "should replace existing names" do
    b1 = double :create => double, :name => 'aBehavior'
    b2 = double :create => double, :name => 'aBehavior'
    Chessmonger::Armory.instance.register b1
    Chessmonger::Armory.instance.register b2
    Chessmonger::Armory.instance.get('aBehavior').should be(b2)
  end

  [ :create, :name ].each do |missing|
    it "should not accept behavior factories which do not respond to :#{missing}" do
      factory = double
      factory.stub :create unless missing == :create
      factory.stub :name unless missing == :name
      lambda{ Chessmonger::Armory.instance.register factory }.should raise_error(ArgumentError)
    end
  end

  [ :each_action, :can_attack?, :name, :name= ].each do |missing|
    it "should not accept behaviors which do not respond to :#{missing}" do
      behavior = double
      behavior.stub :each_action unless missing == :each_action
      behavior.stub :can_attack? unless missing == :can_attack?
      behavior.stub :name unless missing == :name
      behavior.stub :name= unless missing == :name=
      factory = double :create => behavior, :name => 'aBehavior'
      game = double
      player = double
      piece = double :player= => nil, :behavior= => nil
      Chessmonger::Armory.instance.register factory
      Chessmonger::Piece.stub :new => piece
      lambda{ Chessmonger::Armory.instance.train 'aBehavior', game, player }.should raise_error(ArgumentError)
    end
  end

  it "should train pieces with a new instance of the behavior specified by name" do

    piece = double :player= => nil, :behavior= => nil
    Chessmonger::Piece.stub(:new).and_return piece
    behavior = double :each_action => nil, :can_attack? => nil, :name => nil, :name= => nil
    factory = double :create => behavior, :name => 'aBehavior'
    game = double
    player = double

    Chessmonger::Armory.instance.register factory

    factory.should_receive(:create).with game, piece
    Chessmonger::Piece.should_receive :new
    piece.should_receive(:player=).with player
    piece.should_receive(:behavior=).with behavior

    result = Chessmonger::Armory.instance.train 'aBehavior', game, player
    result.should be(piece)
  end
end
