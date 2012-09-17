
# TODO: should be configurable as a DSL with #new

describe 'Config' do

  before :each do
    @behaviors = double
    @behaviors.stub :configure => @behaviors
    Chessmonger::Config::Behaviors.stub :new => @behaviors
    @variant = double
    @variant.stub :configure => @variant
    Chessmonger::Config::Variant.stub :new => @variant
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

  it "should not return variants that have not been registered" do
    @config.variant('international').should be_nil
  end

  it "should register variants" do
    impl = double
    Chessmonger::Config::Variant.should_receive(:new).with(@config)
    @variant.stub :implementation= => nil
    @variant.stub :implementation => impl
    @config.variant 'international', impl
    @config.variant('international').implementation.should be(impl)
  end

  it "should replace existing variants" do
    impl1 = double
    impl2 = double
    Chessmonger::Config::Variant.should_receive(:new).with(@config)
    @variant.stub :implementation= => nil
    @variant.stub :implementation => impl2
    @variant.should_receive(:implementation=).with(impl1)
    @variant.should_receive(:implementation=).with(impl2)
    @config.variant 'international', impl1
    @config.variant 'international', impl2
    @config.variant('international').implementation.should be(impl2)
  end

  it "should identify registered variants" do
    impl = double
    Chessmonger::Config::Variant.should_receive(:new).with(@config)
    @variant.stub :implementation= => nil
    @variant.stub :implementation => impl
    @variant.should_receive :implementation
    @config.variant 'international', impl
    @config.identify(impl).should == 'international'
  end

  it "should not identify unregistered variants" do
    impl = double
    Chessmonger::Config::Variant.should_receive(:new).with(@config)
    @variant.stub :implementation= => nil
    @variant.stub :implementation => impl
    @config.variant 'international', impl
    @config.identify(Object.new).should be_nil
  end

  it "should return the names of registered variants" do
    impl1, impl2 = double, double
    @variant.stub :implementation= => nil
    @variant.stub :implementation => impl1
    @config.variant 'r1', impl1
    @config.variant 'r2', impl2
    @config.variant_names.tap do |names|
      names.should have(2).items
      names.should include('r1', 'r2')
    end
  end

  it "should allow variants to be configured" do
    impl = double
    @variant.stub :implementation= => nil
    @variant.stub :implementation => impl
    @variant.should_receive(:configure).and_yield
    @config.variant 'international', impl do; end
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
