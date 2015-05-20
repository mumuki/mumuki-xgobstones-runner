require_relative 'cell'
require_relative 'position'

class OutOfBoardError < RuntimeError
end

class Board
  attr_reader :size, :cells, :head_position

  def initialize(x, y)
    @size = [x, y]
    @cells = Hash.new(Cell.new)
    @head_position = Position.new(0, 0)
  end

  def add_cell(position, cell)
    @cells[position] = cell
    self
  end

  def move_head_to(position)
    check_is_within_bounds position
    @head_position = position
    self
  end

  def cell_at(position)
    check_is_within_bounds position
    @cells[position]
  end

  def ==(other)
    self.class === other and
        other.size == @size and
        all_cells_equal(other)
  end

  private

  def is_within_bounds(position)
    @size[0] > position.x && @size[1] > position.y
  end

  def check_is_within_bounds(position)
    raise OutOfBoardError unless is_within_bounds(position)
  end

  def all_cells_equal(other)
    @cells.all? { |position, cell| other.cell_at(position) == cell } and
        other.cells.all? { |position, cell| cell_at(position) == cell }
  end
end