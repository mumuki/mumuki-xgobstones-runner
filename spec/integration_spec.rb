require 'spec_helper'
require 'mumukit/bridge'

describe 'runner' do
  let(:bridge) { Mumukit::Bridge::Bridge.new('http://localhost:4567') }

  before(:all) do
    @pid = Process.spawn 'rackup -p 4567'
    sleep 3
  end
  after(:all) { Process.kill 'QUIT', @pid }

  context 'when submission is ok' do
    it 'answers a valid hash' do
      response = bridge.run_tests!(content: '
procedure IrAlOrigen() {
  IrAlBorde(Sur)
  IrAlBorde(Oeste)
}

program {
  VaciarTablero()
  IrAlOrigen()
  Poner(Rojo)
}
', extra: '', test: '
examples:
 - initial_board: |
    GBB/1.0
    size 4 4
    head 3 0

   final_board: |
    GBB/1.0
    size 4 4
    cell 0 0 Rojo 1
    head 0 0
')
      expect(response[:status]).to eq('passed')
    end
  end
end
