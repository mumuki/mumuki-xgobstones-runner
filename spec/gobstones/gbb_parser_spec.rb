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
head 0 0
'
  }

  let (:board) { parser.parseString gbb }

  context 'should parse the size' do
    it { expect(board.size).to eq [4, 4] }
  end
end