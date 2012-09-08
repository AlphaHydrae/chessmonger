
describe 'Rules' do

  def make_rules *pieces
    double.tap do |rules|
      rules.stub :number_of_players => 2
      rules.stub :board_width => 8
      rules.stub :board_height => 8
      rules.stub :pieces => pieces
    end
  end

  before :each do

    @armory = double
    @armory.stub :names => [ 'a', 'b', 'c' ]

    Chessmonger::Armory.stub :instance => @armory
    
    @rules = make_rules 'a', 'b'
  end

  after :each do
    Chessmonger::Rules.instance_variable_set '@rules', {}
  end

  it "should be a singleton" do
    lambda{ Chessmonger::Rules.new }.should raise_error
  end

  it "should be provided as a shorthand by the top module" do
    Chessmonger.rules.should be(Chessmonger::Rules.instance)
  end

  it "should store rules by name" do
    Chessmonger::Rules.instance.register 'someRules', @rules
    Chessmonger::Rules.instance.get('someRules').should be(@rules)
  end

  it "should replace existing names" do
    other_rules = make_rules 'b', 'c'
    Chessmonger::Rules.instance.register 'someRules', other_rules
    Chessmonger::Rules.instance.register 'someRules', @rules
    Chessmonger::Rules.instance.get('someRules').should be(@rules)
  end

  it "should not accept non-rules" do
    lambda{ Chessmonger::Rules.instance.register 'someRules', Object.new }.should raise_error(ArgumentError)
  end

  it "should not accept rules using pieces that are not in the armory" do
    invalid_rules = make_rules 'a', 'd'
    lambda{ Chessmonger::Rules.instance.register 'someRules', invalid_rules }.should raise_error(ArgumentError)
  end
end
