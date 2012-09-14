
describe 'HQ Behaviors' do

  before :each do
    @behaviors = Chessmonger::HQ::Behaviors.new
    @behavior = double
  end

  it "should not return behaviors that have not been registered" do
    @behaviors.get('aBehavior').should be_nil
  end

  it "should add a behavior by name" do
    @behaviors.add 'aBehavior', @behavior
    @behaviors.get('aBehavior').should be(@behavior)
  end

  it "should add behaviors with options" do
    @behaviors.add 'aBehavior', @behavior, :a => 'b', :c => 'd'
    @behaviors.options('aBehavior').should == { :a => 'b', :c => 'd' }
  end

  it "should replace existing behaviors" do
    other = double
    @behaviors.add 'aBehavior', @behavior
    @behaviors.add 'aBehavior', other
    @behaviors.get('aBehavior').should be(other)
  end

  it "should replace the options of existing behaviors" do
    other = double
    @behaviors.add 'aBehavior', @behavior, :a => 'b', :c => 'd'
    @behaviors.add 'aBehavior', other, :e => 'f', :g => 'h'
    @behaviors.options('aBehavior').should == { :e => 'f', :g => 'h' }
  end

  it "should delete behaviors by name" do
    @behaviors.add 'aBehavior', @behavior
    @behaviors.delete 'aBehavior'
    @behaviors.get('aBehavior').should be_nil
    @behaviors.options('aBehavior').should be_nil
  end

  it "should provide the names of registered behaviors" do
    @behaviors.add 'aBehavior', @behavior
    @behaviors.add 'anotherBehavior', double
    @behaviors.names.tap do |names|
      names.should have(2).items
      names.should include('aBehavior', 'anotherBehavior')
    end
  end

  it "should identify a registered behavior" do
    @behaviors.add 'aBehavior', @behavior
    @behaviors.identify(@behavior).should == 'aBehavior'
  end

  it "should identify an instance of a registered behavior" do
    instance = double
    instance.stub(:instance_of?){ |type| type == @behavior }
    @behaviors.add 'aBehavior', @behavior
    @behaviors.identify(instance).should == 'aBehavior'
  end

  def spec_behaviors
    @behaviors
  end

  it "should be configurable as a DSL" do
    @behaviors.configure do
      self.should be(spec_behaviors)
    end
  end
end
