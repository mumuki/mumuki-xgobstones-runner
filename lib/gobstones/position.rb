class Position
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def ==(other)
    self.class === other and
        other.x == @x and
        other.y == @y
  end

  alias eql? ==

  def hash
    @x.hash ^ @y.hash
  end
end