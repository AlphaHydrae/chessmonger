
# TODO: implement replace
#       example: replace 'intKnight', 'jediKnight', :letter => 'k'

describe 'HQ Armory' do

  before :each do
    @hq = double

    @int_pawn = double
    @int_pawn_options = { :a => 'b', :c => 'd' }
    @behaviors = double
    @behaviors.stub :get do |name|
      name == 'intPawn' ? @int_pawn : nil
    end
    @behaviors.stub :options do |name|
      name == 'intPawn' ? @int_pawn_options : nil
    end
    @hq.stub :behaviors => @behaviors

    @int = double
    @hq.stub :rules do |name|
      name == 'international' ? @int : nil
    end

    @armory = Chessmonger::HQ::Armory.new @hq
  end

  it "should use the specified behavior from HQ" do
    @behaviors.should_receive(:get).with 'intPawn'
    @armory.use 'intPawn'
    @armory.get('intPawn').should be(@int_pawn)
  end

  it "should copy the options of the behavior from HQ" do
    @behaviors.should_receive(:options).with 'intPawn'
    @armory.use 'intPawn'
    @armory.options('intPawn').should == @int_pawn_options
    @armory.options('intPawn').should_not be(@int_pawn_options)
  end

  it "should override the options of the behavior from HQ" do
    new_options = { :c => 'e', :f => 'g' }
    @armory.use 'intPawn', new_options
    @armory.options('intPawn').should == @int_pawn_options.merge(new_options)
  end

  it "should copy an existing armory" do
    
    existing = Chessmonger::HQ::Armory.new @hq
    existing_options = { :c => 'e', :f => 'g' }
    existing.use 'intPawn', existing_options
    @int.stub :armory => existing

    @armory.copy 'international'
    @armory.get('intPawn').should be(@int_pawn)
    @armory.options('intPawn').should == @int_pawn_options.merge(existing_options)
  end

  it "should return the names of registered behaviors" do
    @armory.use 'intPawn'
    @armory.names.should == [ 'intPawn' ]
  end

  it "should delete behaviors by name" do
    @armory.use 'intPawn'
    @armory.delete 'intPawn'
    @armory.get('intPawn').should be_nil
  end

  def spec_armory
    @armory
  end

  it "should be configurable as a DSL" do
    @armory.configure do
      self.should be(spec_armory)
    end
  end

  it "should raise an error if the behavior name does not exist" do
    lambda{ @armory.use 'fubar' }.should raise_error(ArgumentError)
  end

  it "should raise an error when trying to copy the armory of rules that do not exist" do
    lambda{ @armory.copy 'fubar' }.should raise_error(ArgumentError)
  end
end
