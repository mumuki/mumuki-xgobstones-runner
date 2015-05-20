require 'rspec'

require_relative '../../lib/gobstones/gbb_parser'

describe GbbParser do
  let (:parser) { GbbParser.new }

  let (:gbb) {
'GBB/1.0
size 4 4
cell 0 0 Rojo 1 Verde 2 Azul 5
cell 0 1 Negro 3
cell 1 0 Negro 3 Rojo 0 Verde 0 Azul 0
head 3 3'
  }

  let (:board) { parser.from_string gbb }

  context 'should create a board with the proper size' do
    it { expect(board.size).to eq [4, 4] }
  end

  context 'should set the position of the head' do
    it { expect(board.head_position).to eq Position.new(3, 3) }
  end

  context 'should set the cells' do
    it { expect(board.cell_at(Position.new 0, 0)).to eq Cell.new(red: 1, green: 2, blue: 5) }
    it { expect(board.cell_at(Position.new 0, 1)).to eq Cell.new(black: 3) }
  end
end