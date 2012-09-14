
describe 'HQ' do

  before :each do
    @behaviors = double
    @behaviors.stub :configure => @behaviors
    Chessmonger::HQ::Behaviors.stub :new => @behaviors
    @rules = double
    @rules.stub :configure => @rules
    Chessmonger::HQ::Rules.stub :new => @rules
    @hq = Chessmonger::HQ.new
  end

  it "should have behaviors" do
    @hq.behaviors.should be(@behaviors)
  end

  it "should allow its behaviors to be configured" do
    @behaviors.should_receive(:configure).and_yield
    @hq.behaviors do; end
  end

  it "should not return rules that have not been registered" do
    @hq.rules('international').should be_nil
  end

  it "should register rules" do
    impl = double
    Chessmonger::HQ::Rules.should_receive(:new).with(@hq)
    @rules.stub :implementation= => nil
    @rules.stub :implementation => impl
    @hq.rules 'international', impl
    @hq.rules('international').should_not be_nil
    @hq.rules('international').implementation.should be(impl)
  end

  it "should replace existing rules" do
    impl1 = double
    impl2 = double
    Chessmonger::HQ::Rules.should_receive(:new).with(@hq)
    @rules.stub :implementation= => nil
    @rules.stub :implementation => impl2
    @rules.should_receive(:implementation=).with(impl1)
    @rules.should_receive(:implementation=).with(impl2)
    @hq.rules 'international', impl1
    @hq.rules 'international', impl2
    @hq.rules('international').implementation.should be(impl2)
  end

  it "should allow rules to be configured" do
    impl = double
    @rules.stub :implementation= => nil
    @rules.stub :implementation => impl
    @rules.should_receive(:configure).and_yield
    @hq.rules 'international', impl do; end
  end

  def spec_hq
    @hq
  end

  it "should be configurable as a DSL" do
    @hq.configure do
      self.should be(spec_hq)
    end
  end
end
