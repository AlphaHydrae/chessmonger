
describe 'Rulebook Rules Serializer' do

  def spec_impl
    @impl
  end

  before :each do
    @impl = double
    @config = Chessmonger::Config.new
    @config.configure do
      variant 'InternationalChess', spec_impl
    end
    @rulebook = double :config => @config
    @serializer = Chessmonger::Rulebook::RulesSerializer.new @rulebook
  end

  it "should load the rules" do
    @rulebook.should_receive :config
    @serializer.load('InternationalChess').should be(@impl)
  end

  it "should save the rules" do
    @rulebook.should_receive :config
    @serializer.save(@impl).should == 'InternationalChess'
  end
end
