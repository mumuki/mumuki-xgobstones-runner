require_relative 'cell'

class OutOfBoundsError < RuntimeError
end

class Board
  def initialize(x, y)
    @size = [x, y]
    @cells = Hash.new(Cell.new)
  end

  def add_cell(position, cell)
    @cells[position] = cell
    self
  end

  def cell_at(position)
    raise OutOfBoundsError unless contains(position)
    @cells[position]
  end

  def contains(position)
    @size[0] > position.x && @size[1] > position.y
  end
end