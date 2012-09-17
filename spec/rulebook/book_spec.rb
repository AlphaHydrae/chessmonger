
describe 'Rulebook' do

  it "should be provided as a singleton attached to the top module" do
    Chessmonger.rulebook.tap do |book|
      book.should be_a_kind_of(Chessmonger::Rulebook)
      book.should be(Chessmonger.rulebook)
    end
  end

  describe 'when loaded' do

    before :each do
      @rulebook = Chessmonger::Rulebook.new.tap{ |book| book.load! }
    end

    it "should create a game of the specified variant" do
      p1, p2 = Chessmonger::Player.new('John Doe'), Chessmonger::Player.new('Jane Doe')
      @rulebook.new_game('InternationalChess', [ p1, p2 ]).tap do |game|
        game.rules.should be(@rulebook.config.variant('InternationalChess').implementation)
        game.players.should == [ p1, p2 ]
        game.history.should be_empty
      end
    end

    it "should raise an error when trying to create a game for an unregistered variant" do
      lambda{ @rulebook.new_game 'Fubar', [] }.should raise_error(ArgumentError)
    end

    [
      {
        :name => 'InternationalChess',
        :behaviors => [
          { :name => 'Pawn', :letter => 'p' },
          { :name => 'King', :letter => 'k' }
        ]
      }
    ].each do |variant|

      it "should have all #{variant[:name]} correctly registered" do
        variant_class = Chessmonger::Variants.const_get variant[:name]
        variant_class.should_not be_nil
        variant[:behaviors].each do |behavior|
          behavior_class = variant_class.const_get behavior[:name]
          behavior_class.should_not be_nil
          id = @rulebook.config.behaviors.identify behavior_class
          id.should_not be_nil
          registered_variant = @rulebook.config.variant variant[:name]
          registered_variant.should_not be_nil
          registered_variant.armory.get(id).should be(behavior_class)
          registered_variant.armory.options(id)[:letter].should == behavior[:letter]
        end
      end
    end
  end
end
