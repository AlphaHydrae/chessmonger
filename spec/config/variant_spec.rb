
describe 'Config Variant' do

  before :each do
    @config = double
    @armory = double
    @armory.stub :configure => @armory
    Chessmonger::Config::Armory.stub :new => @armory
    Chessmonger::Config::Armory.should_receive(:new).with(@config)
    @variant = Chessmonger::Config::Variant.new @config
  end

  it "should accept an implementation" do
    @impl = double
    @variant.implementation = @impl
    @variant.implementation.should be(@impl)
  end

  it "should have an armory" do
    @variant.armory.should be(@armory)
  end

  it "should give access to the armory as a DSL" do
    @armory.should_receive(:configure).and_yield
    @variant.armory do; end
  end

  def spec_rules
    @variant
  end

  it "should be configurable as a DSL" do
    @variant.configure do
      self.should be(spec_rules)
    end
  end
end
