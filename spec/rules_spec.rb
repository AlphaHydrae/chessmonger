
describe 'Rules' do

  def make_rules options = {}
    double.tap do |rules|
      rules.stub :number_of_players => 2 unless options[:number_of_players] == false
      rules.stub :board_width => 8 unless options[:board_width] == false
      rules.stub :board_height => 8 unless options[:board_height] == false
      rules.stub :playing_direction => double unless options[:playing_direction] == false
      rules.stub :pieces => (options[:pieces] || [ 'a', 'b' ]) unless options[:pieces] == false
      rules.stub :setup => nil unless options[:setup] == false
      rules.stub :allowed? => true unless options[:allowed?] == false
      rules.stub :actions => [] unless options[:actions] == false
      rules.stub :player => double( :name => 'John Doe' ) unless options[:player] == false
    end
  end

  before :each do

    @armory = double
    @armory.stub :names => [ 'a', 'b', 'c' ]

    Chessmonger::Armory.stub :instance => @armory
    
    @rules = make_rules
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
    other_rules = make_rules
    Chessmonger::Rules.instance.register 'someRules', other_rules
    Chessmonger::Rules.instance.register 'someRules', @rules
    Chessmonger::Rules.instance.get('someRules').should be(@rules)
  end

  it "should not accept non-rules" do
    lambda{ Chessmonger::Rules.instance.register 'someRules', Object.new }.should raise_error(ArgumentError)
  end

  [
    :number_of_players, :board_width, :board_height, :playing_direction,
    :pieces, :setup, :allowed?, :actions, :player
  ].each do |missing|
    it "should not accept rules which do not respond to :#{missing}" do
      options = {}
      options[missing] = false
      invalid_rules = make_rules options
      lambda{ Chessmonger::Rules.instance.register 'someRules', invalid_rules }.should raise_error(ArgumentError)
    end
  end

  it "should not accept rules using pieces that are not in the armory" do
    invalid_rules = make_rules :pieces => [ 'a', 'd' ]
    lambda{ Chessmonger::Rules.instance.register 'someRules', invalid_rules }.should raise_error(ArgumentError)
  end
end
