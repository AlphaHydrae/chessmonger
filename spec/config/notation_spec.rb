
describe 'Config Notation' do

  before :each do
    @config = double
    @notation = Chessmonger::Config::Notation.new @config
  end

  it "should accept an implementation" do
    @impl = double :new => nil
    @notation.implementation = @impl
    @notation.implementation.should be(@impl)
  end

  it "should create an instance" do
    @instance = double
    @impl = double :new => @instance
    @notation.implementation = @impl
    @notation.create.should be(@instance)
  end

  it "should allow supported variants to be specified" do
    @config.stub :rule_names => [ 'v1', 'v2', 'v3' ]
    @config.should_receive :rule_names
    @notation.variants 'v1', 'v2'
    @notation.supported_variants.tap do |names|
      names.should have(2).items
      names.should include('v1', 'v2')
    end
  end

  it "should not accept variants that have not been registered" do
    @config.stub :rule_names => [ 'v1', 'v2', 'v3' ]
    @config.should_receive :rule_names
    lambda{ @notation.variants 'v3', 'v4' }.should raise_error(ArgumentError)
  end

  it "should raise an error if trying to create an instance without an implementation" do
    lambda{ @notation.create }.should raise_error(ArgumentError)
  end

  it "should not accept an implementation that does not respond to #new" do
    @impl = double
    lambda{ @notation.implementation = @impl }.should raise_error(ArgumentError)
  end

  def spec_notation
    @notation
  end

  it "should be configurable as a DSL" do
    @notation.configure do
      self.should be(spec_notation)
    end
  end
end
