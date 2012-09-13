
describe 'HQ Behaviors' do

  before :each do
    @behaviors = Chessmonger::HQ::Behaviors.new
    @behavior = double
  end

  it "should register a behavior by name" do
    @behaviors.add 'aBehavior', @behavior
    @behaviors.get('aBehavior').should be(@behavior)
  end

  it "should replace existing behaviors" do
    other = double
    @behaviors.add 'aBehavior', @behavior
    @behaviors.add 'aBehavior', other
    @behaviors.get('aBehavior').should be(other)
  end

  it "should delete behaviors by name" do
    @behaviors.add 'aBehavior', @behavior
    @behaviors.delete 'aBehavior'
    @behaviors.get('aBehavior').should be_nil
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

  describe 'DSL' do
    
    it "should register a behavior by name" do
      @behaviors.configure do
        add 'aBehavior', @behavior
        get('aBehavior').should be(@behavior)
      end
    end

    it "should replace existing behaviors" do
      @behaviors.configure do
        other = double
        add 'aBehavior', @behavior
        add 'aBehavior', other
        get('aBehavior').should be(other)
      end
    end

    it "should delete behaviors by name" do
      @behaviors.configure do
        add 'aBehavior', @behavior
        delete 'aBehavior'
        get('aBehavior').should be_nil
      end
    end

    it "should provide the names of registered behaviors" do
      @behaviors.configure do
        add 'aBehavior', @behavior
        add 'anotherBehavior', double
        names.tap do |names|
          names.should have(2).items
          names.should include('aBehavior', 'anotherBehavior')
        end
      end
    end
  end
end
