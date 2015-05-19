require_relative 'cell'

class OutOfBoundsError < RuntimeError
end

class Board
  attr_reader :size, :cells

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

  def ==(other)
    self.class === other and
        other.size == @size and
        all_cells_equal(other)
  end

  def all_cells_equal(other)
    @cells.all? { |position, cell| other.cell_at(position) == cell } and
        other.cells.all? { |position, cell| cell_at(position) == cell }
  end
end