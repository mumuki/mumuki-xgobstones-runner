require 'rspec'

require_relative '../../lib/gobstones/board'
require_relative '../../lib/gobstones/position'
require_relative '../../lib/gobstones/cell'

describe Board do
  context 'should store cells' do
    let(:board) { Board.new(4, 4).add_cell(Position.new(0, 0), Cell.new(blue=3)) }

    it { expect(board.cell_at(Position.new(0, 0))).to eq(Cell.new(blue=3)) }
    it { expect(board.cell_at(Position.new(0, 1))).to eq(Cell.new) }
    it { lambda { board.cell_at(Position.new(4, 4)) }.should raise_error(OutOfBoundsError) }
  end
end