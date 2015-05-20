require 'rspec'
require_relative '../../lib/gobstones'

include Gobstones

describe Board do
  context 'should store cells' do
    let(:board) { Board.new(4, 4).add_cell(Position.new(0, 0), Cell.new(blue: 3)) }

    it { expect(board.cell_at(Position.new(0, 0))).to eq(Cell.new(blue: 3)) }
    it { expect(board.cell_at(Position.new(0, 1))).to eq(Cell.new) }
    it { expect { board.cell_at(Position.new(4, 4)) }.to raise_error(OutOfBoardError) }
  end

  context 'should validate head movements' do
    let(:board) { Board.new(4, 4) }

    it { expect(board.move_head_to(Position.new(0, 3)).head_position).to eq(Position.new(0, 3)) }
    it { expect { board.move_head_to(Position.new(4, 4)) }.to raise_error(OutOfBoardError) }
  end

  context 'should be able to compare itself with another board' do
    let(:board) {
      Board.new(4, 4)
        .add_cell(Position.new(0, 0), Cell.new(blue: 3, red: 8))
        .add_cell(Position.new(0, 1), Cell.new(green: 4))
    }

    it { expect(board).not_to eq(Board.new(4, 4)) }

    it {
      another = Board.new(4, 4).add_cell(Position.new(0, 0), Cell.new(blue: 3, red: 8))
      expect(board).not_to eq(another)
    }

    it {
      another = Board.new(4, 4).add_cell(Position.new(0, 1), Cell.new(green: 4)).add_cell(Position.new(0, 0), Cell.new(blue: 3, red: 8))
      expect(board).to eq(another)
    }

    it {
      another = Board.new(4, 4)
        .add_cell(Position.new(0, 1), Cell.new(green: 4))
        .add_cell(Position.new(0, 0), Cell.new(blue: 3, red: 8))
        .add_cell(Position.new(1, 0), Cell.new(black: 7))

      expect(board).not_to eq(another)
    }
  end
end