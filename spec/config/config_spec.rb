
# TODO: should be configurable as a DSL with #new

describe 'Config' do

  before :each do
    @behaviors = double
    @behaviors.stub :configure => @behaviors
    Chessmonger::Config::Behaviors.stub :new => @behaviors
    @rules = double
    @rules.stub :configure => @rules
    Chessmonger::Config::Rules.stub :new => @rules
    @notation = double
    @notation.stub :configure => @notation
    Chessmonger::Config::Notation.stub :new => @notation
    @config = Chessmonger::Config.new
  end

  it "should have behaviors" do
    @config.behaviors.should be(@behaviors)
  end

  it "should allow its behaviors to be configured" do
    @behaviors.should_receive(:configure).and_yield
    @config.behaviors do; end
  end

  it "should not return rules that have not been registered" do
    @config.rules('international').should be_nil
  end

  it "should register rules" do
    impl = double
    Chessmonger::Config::Rules.should_receive(:new).with(@config)
    @rules.stub :implementation= => nil
    @rules.stub :implementation => impl
    @config.rules 'international', impl
    @config.rules('international').implementation.should be(impl)
  end

  it "should replace existing rules" do
    impl1 = double
    impl2 = double
    Chessmonger::Config::Rules.should_receive(:new).with(@config)
    @rules.stub :implementation= => nil
    @rules.stub :implementation => impl2
    @rules.should_receive(:implementation=).with(impl1)
    @rules.should_receive(:implementation=).with(impl2)
    @config.rules 'international', impl1
    @config.rules 'international', impl2
    @config.rules('international').implementation.should be(impl2)
  end

  it "should return the names of registered rules" do
    impl1, impl2 = double, double
    @rules.stub :implementation= => nil
    @rules.stub :implementation => impl1
    @config.rules 'r1', impl1
    @config.rules 'r2', impl2
    @config.rule_names.tap do |names|
      names.should have(2).items
      names.should include('r1', 'r2')
    end
  end

  it "should allow rules to be configured" do
    impl = double
    @rules.stub :implementation= => nil
    @rules.stub :implementation => impl
    @rules.should_receive(:configure).and_yield
    @config.rules 'international', impl do; end
  end

  it "should register notations" do
    impl = double
    Chessmonger::Config::Notation.should_receive(:new).with(@config)
    @notation.stub :implementation= => nil
    @config.notation 'cmgn', impl
  end

  it "should replace existing notations" do
    impl1 = double
    impl2 = double
    Chessmonger::Config::Notation.should_receive(:new).with(@config)
    @notation.stub :implementation= => nil
    @notation.should_receive(:implementation=).with(impl1)
    @notation.should_receive(:implementation=).with(impl2)
    @config.notation 'cmgn', impl1
    @config.notation 'cmgn', impl2
  end

  it "should return the names of registered notations" do
    impl1, impl2 = double, double
    @notation.stub :implementation= => nil
    @config.notation 'cmgn', impl1
    @config.notation 'pgn', impl2
    @config.notation_names.tap do |names|
      names.should have(2).items
      names.should include('cmgn', 'pgn')
    end
  end

  it "should allow notations to be configured" do
    impl = double
    @notation.stub :implementation= => nil
    @notation.should_receive(:configure).and_yield
    @config.notation 'cmgn', impl do; end
  end

  def spec_config
    @config
  end

  it "should be configurable as a DSL" do
    @config.configure do
      self.should be(spec_config)
    end
  end
end
