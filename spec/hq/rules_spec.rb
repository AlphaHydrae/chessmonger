
describe 'HQ Rules' do

  before :each do
    @hq = double
    @armory = double
    @armory.stub :configure => @armory
    Chessmonger::HQ::Armory.stub :new => @armory
    Chessmonger::HQ::Armory.should_receive(:new).with(@hq)
    @rules = Chessmonger::HQ::Rules.new @hq
  end

  it "should accept an implementation" do
    @impl = double
    @rules.implementation = @impl
    @rules.implementation.should be(@impl)
  end

  it "should have an armory" do
    @rules.armory.should be(@armory)
  end

  it "should give access to the armory as a DSL" do
    @armory.should_receive(:configure).and_yield
    @rules.armory do; end
  end

  def spec_rules
    @rules
  end

  it "should be configurable as a DSL" do
    @rules.configure do
      self.should be(spec_rules)
    end
  end
end
