require 'spec_helper'
require 'mumukit/bridge'

describe 'runner' do
  let(:bridge) { Mumukit::Bridge::Bridge.new('http://localhost:4567') }

  before(:all) do
    @pid = Process.spawn 'rackup -p 4567', err: '/dev/null'
    sleep 3
  end

  after(:all) { Process.kill 'TERM', @pid }

  context 'when submission is ok' do
    let(:content) { '
procedure PonerUnaDeCada() {
    Poner (Rojo)
    Poner (Azul)
    Poner (Negro)
    Poner (Verde)
}' }

    let(:test) { '
check_head_position: true

subject: PonerUnaDeCada

examples:
 - initial_board: |
     GBB/1.0
     size 4 4
     head 0 0
   final_board: |
     GBB/1.0
     size 4 4
     cell 0 0 Azul 1 Rojo 1 Verde 1 Negro 1
     head 0 0

 - initial_board: |
     GBB/1.0
     size 5 5
     head 3 3
   final_board: |
     GBB/1.0
     size 5 5
     cell 3 3 Azul 1 Rojo 1 Verde 1 Negro 1
     head 3 3' }

    let(:expectations) { [{binding: 'PonerUnaDeCada', inspection: 'HasUsage'}] }
    let(:extra) { '' }

    let(:response) { bridge.run_tests! content: content, extra: extra, expectations: expectations, test: test }

    it { expect(response[:status]).to eq 'passed' }
    it { expect(response[:result]).to include '<div>' }
    it { expect(response[:expectation_results]).to eq [{:binding=>'PonerUnaDeCada', :inspection=>'HasUsage', :result=>:passed}] }
  end
end
