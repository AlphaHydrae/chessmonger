
describe 'HQ' do

  before :each do
    @behaviors = double
    @behaviors.stub :configure => @behaviors
    Chessmonger::HQ::Behaviors.stub :new => @behaviors
    @hq = Chessmonger::HQ.new
  end

  it "should have behaviors" do
    @hq.behaviors.should be(@behaviors)
  end

  it "should allow its behaviors to be configured" do
    @behaviors.should_receive(:configure).and_yield
    @hq.behaviors do; end
  end
end
