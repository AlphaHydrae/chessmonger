require 'ostruct'

describe 'Distance' do

  it "should calculate the horizontal distance" do
    a = OpenStruct.new :x => 4, :y => 4
    8.times do |i|
      8.times do |j|
        b = OpenStruct.new :x => i + 1, :y => j + 1
        Chessmonger::Distance.horizontal(a, b).should == i - 4 + 1
      end
    end
  end

  it "should calculate the vertical distance" do
    a = OpenStruct.new :x => 4, :y => 4
    8.times do |i|
      8.times do |j|
        b = OpenStruct.new :x => i + 1, :y => j + 1
        Chessmonger::Distance.vertical(a, b).should == j - 4 + 1
      end
    end
  end

  it "should calculate the longest distance (horizontal/vertical)" do
    a = OpenStruct.new :x => 4, :y => 4
    b = OpenStruct.new :x => 6, :y => 7
    Chessmonger::Distance.longest(a, b).should == 3
  end

  it "should calculate the product of distances (horizontal/vertical)" do
    a = OpenStruct.new :x => 4, :y => 4
    b = OpenStruct.new :x => 6, :y => 7
    Chessmonger::Distance.product(a, b).should == 6
  end
end
