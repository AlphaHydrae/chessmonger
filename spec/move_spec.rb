
describe 'Move' do

  before :each do

    @board = double('board')
    
    @game = double('game')
    @game.stub(:board){ @board }
  end
end
