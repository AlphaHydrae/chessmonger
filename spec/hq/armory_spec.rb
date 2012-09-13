
describe 'Armory' do

  # TODO: check type of behavior when creating

  before :each do
    @armory = Chessmonger::Armory.new
    @behavior = double
  end

  it "should register a behavior by name" do
    @armory.add 'aBehavior', @behavior
    @armory.get('aBehavior').should be(@behavior)
  end

  it "should replace existing behaviors" do
    other = double
    @armory.add 'aBehavior', @behavior
    @armory.add 'aBehavior', other
    @armory.get('aBehavior').should be(other)
  end

  it "should delete behaviors by name" do
    @armory.add 'aBehavior', @behavior
    @armory.delete 'aBehavior'
    @armory.get('aBehavior').should be_nil
  end

  it "should provide the names of registered behaviors" do
    @armory.add 'aBehavior', @behavior
    @armory.add 'anotherBehavior', double
    @armory.names.should == [ 'aBehavior', 'anotherBehavior' ]
  end
end
