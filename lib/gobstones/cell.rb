class Cell
  attr_accessor :red, :green, :blue, :black

  def initialize(red: 0, green: 0, blue: 0, black: 0)
    @red = red
    @green = green
    @blue = blue
    @black = black
  end

  def set(color, quantity)
    send "#{color}=", quantity
  end

  def ==(other)
    self.class === other and
        other.red == @red and
        other.green == @green and
        other.blue == @blue and
        other.black == @black
  end

  alias eql? ==

  def hash
    @red.hash ^ @green.hash ^ @blue.hash ^ @black.hash
  end
end