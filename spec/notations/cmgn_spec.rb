
# TODO: check every parse error
# TODO: check move format

describe 'CMGN' do

  before :each do

    @p1, @p2 = Chessmonger::Player.new('John Doe'), Chessmonger::Player.new('Jane Doe')
    @rules = Chessmonger::Variants::InternationalChess.new
    @game = Chessmonger::Game.new @rules, [ @p1, @p2 ]
    @rules.setup @game

    @notation = Chessmonger::Notations::CMGN.new
    @rules_serializer = double :save => 'InternationalChess', :load => Chessmonger::Variants::InternationalChess.new
    @piece_serializer = double
    @piece_serializer.stub :save do |piece,game|
      if piece.behavior.instance_of? Chessmonger::Variants::InternationalChess::Pawn
        'p'
      elsif piece.behavior.instance_of? Chessmonger::Variants::InternationalChess::King
        'k'
      end
    end
    #@piece_serializer.stub :load do |string,game|
    #  case string
    #  when 'p'; return Chessmonger::Variants::InternationalChess::Pawn.new
    #  when 'k'; return Chessmonger::Variants::InternationalChess::King.new
    #  end
    #end
  end

  it "should raise a config error if no rules serializer has been set" do
    @notation.piece_serializer = @piece_serializer
    lambda{ @notation.load(nil) }.should raise_error(Chessmonger::Notations::ConfigError){ |e| e.config.should == :rules_serializer }
    lambda{ @notation.save(nil) }.should raise_error(Chessmonger::Notations::ConfigError){ |e| e.config.should == :rules_serializer }
  end

  it "should raise a config error if no piece serializer has been set" do
    @notation.rules_serializer = @rules_serializer
    lambda{ @notation.load(nil) }.should raise_error(Chessmonger::Notations::ConfigError){ |e| e.config.should == :piece_serializer }
    lambda{ @notation.save(nil) }.should raise_error(Chessmonger::Notations::ConfigError){ |e| e.config.should == :piece_serializer }
  end

  describe 'configured' do
    include NotationSpecGenerator

    before :each do
      @notation.rules_serializer = @rules_serializer
      @notation.piece_serializer = @piece_serializer
    end

    it "should save the rules" do
      @rules_serializer.should_receive(:save).with @game.rules
      @notation.save @game
    end

    it "should load the rules" do
      @rules_serializer.should_receive(:load).with 'InternationalChess'
      @notation.load "CMGN 1\nRules InternationalChess\nP1 John Doe\nP2 Jane Doe"
    end

    it "should raise a parse error for an empty file" do
      [ nil, "" ].each do |invalid|
        lambda{ @notation.load(invalid) }.should raise_error(Chessmonger::Notations::ParseError){ |e| e.line.should be_nil }
      end
    end

    it "should raise a parse error if the first line has the wrong format" do
      [ 'CMGN', 'CMGN a', 'fubar' ].each do |invalid|
        lambda{ @notation.load(invalid) }.should raise_error(Chessmonger::Notations::ParseError){ |e| e.line.should == 1 }
      end
    end

    it "should raise an unsupported version error if the version is unexpected" do
      lambda{ @notation.load('CMGN 42') }.should raise_error(Chessmonger::Notations::UnsupportedVersionError){ |e| e.line.should == 1 }
    end

    it "should raise a parse error if a header has the wrong format" do
      [ "CMGN 1\nfubar", "CMGN 1\nH1 correct\n ", "CMGN 1\nH1 correct\nH2 correct\n$$" ].each_with_index do |invalid,i|
        lambda{ @notation.load(invalid) }.should raise_error(Chessmonger::Notations::ParseError){ |e| e.line.should == i + 2 }
      end
    end

    it "should raise an error if the rules header is missing" do
      invalid = "CMGN 1\nP1 John Doe\nP2 Jane Doe"
      lambda{ @notation.load(invalid) }.should raise_error(Chessmonger::Notations::HeaderError){ |e| e.header.should == 'Rules' }
    end

    it "should save and load an empty game correctly" do
      save = @notation.save @game
      copy = @notation.load save
      they_should_be_the_same_game copy, @game
      @notation.save(copy).should == save
    end

    it "should save and load an ongoing game correctly" do
      5.times{ @game.play @game.current_actions.sample }
      save = @notation.save @game
      copy = @notation.load save
      they_should_be_the_same_game copy, @game
      @notation.save(copy).should == save
    end
  end
end
