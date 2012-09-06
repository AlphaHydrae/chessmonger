
describe 'Player' do

  it "should be initializable with a string" do
    lambda{ Player.new 'John Doe' }.should_not raise_error
  end

  it "should have a name" do
    Player.new('John Doe').name.should == 'John Doe'
  end

  it "should only accept a string as argument" do
    [ nil, false, true, Object.new, [], {}, :symbol, -2, 0, 3, 4.5 ].each do |invalid|
      lambda{ Player.new invalid }.should raise_error
    end
  end
end
