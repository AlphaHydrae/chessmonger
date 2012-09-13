
describe 'HQ' do

  # TODO: switch to factory

  before :each do
    @hq = Chessmonger::HQ.new
    @rules = double
  end

  it "should store rules by name" do
    Chessmonger::HQ.rules.add 'someRules', @rules
    Chessmonger::HQ.rules.get('someRules').should be(@rules)
  end

  it "should replace existing rules" do
    other_rules = make_rules
    Chessmonger::Rules.instance.register 'someRules', other_rules
    Chessmonger::Rules.instance.register 'someRules', @rules
    Chessmonger::Rules.instance.get('someRules').should be(@rules)
  end

  it "should not accept non-rules" do
    lambda{ Chessmonger::Rules.instance.register 'someRules', Object.new }.should raise_error(ArgumentError)
  end
end
