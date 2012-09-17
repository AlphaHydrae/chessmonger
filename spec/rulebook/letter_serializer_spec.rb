
describe 'Rulebook Letter Serializer' do

  def spec_impl
    @impl
  end

  before :each do
    @impl = double
    @config = Chessmonger::Config.new
    @config.configure do
      behaviors do
        add 'ChessPawn', Chessmonger::Variants::InternationalChess::Pawn, :letter => 'p'
        add 'ChessKing', Chessmonger::Variants::InternationalChess::King, :letter => 'k'
      end
      variant 'InternationalChess', spec_impl do
        armory do
          use 'ChessPawn'
          use 'ChessKing'
        end
      end
    end
    @game = double
    @serializer = Chessmonger::Rulebook::LetterSerializer.new @config.variant('InternationalChess')
  end

  it "should save pieces as a single letter" do
    piece = Chessmonger::Piece.new
    piece.player = double :name => 'John Doe'
    piece.behavior = Chessmonger::Variants::InternationalChess::Pawn.new
    @serializer.save(piece, @game).should == 'p'
    piece.behavior = Chessmonger::Variants::InternationalChess::King.new
    @serializer.save(piece, @game).should == 'k'
  end

  it "should match pieces" do
    pawn = Chessmonger::Piece.new
    pawn.player = double :name => 'John Doe'
    pawn.behavior = Chessmonger::Variants::InternationalChess::Pawn.new
    king = Chessmonger::Piece.new
    king.player = double :name => 'John Doe'
    king.behavior = Chessmonger::Variants::InternationalChess::King.new
    @serializer.match?(pawn, 'p', @game).should be_true
    @serializer.match?(king, 'p', @game).should be_false
    @serializer.match?(king, 'k', @game).should be_true
    @serializer.match?(pawn, 'k', @game).should be_false
  end
end
