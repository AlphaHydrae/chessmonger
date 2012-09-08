
describe 'Rules' do

  before :each do
    
    @rules = double
    @rules.stub :number_of_players => 2
    @rules.stub :board_width => 8
    @rules.stub :board_height => 8
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

    other_rules = double
    other_rules.stub :number_of_players => 2
    other_rules.stub :board_width => 8
    other_rules.stub :board_height => 8

    Chessmonger::Rules.instance.register 'someRules', other_rules
    Chessmonger::Rules.instance.register 'someRules', @rules
    Chessmonger::Rules.instance.get('someRules').should be(@rules)
  end

  it "should not accept non-rules" do
    lambda{ Chessmonger::Rules.instance.register Object.new }.should raise_error(ArgumentError)
  end
end
