require_relative './spec_helper'

require_relative '../lib/expectations_runner'


describe ExpectationsRunner do
  let(:runner) { ExpectationsRunner.new }
  let(:program) { 'program { Foo() } procedure Foo() {}' }
  let(:bar) {   'program {
    DibujarMacetero(Rojo)
    IrAlBorde(Este) ; Mover(Oeste)
    DibujarMacetero(Azul)
    IrAlBorde(Norte) ; Mover(Sur)
    DibujarMacetero(Verde)
    IrAlBorde(Oeste)
    DibujarMacetero(Negro)
}' }

  let(:foo_expectation) { {'binding' => 'program', 'inspection' => 'HasUsage:Foo'} }
  let(:bar_expectation) { {'binding' => 'program', 'inspection' => 'HasUsage:Bar'} }
  let(:unknown_expectation) { {'binding' => 'program', 'inspection' => 'HasBinding'} }
  let(:foo) { {'binding' => 'program', 'inspection' => 'HasUsage:DibujarMacetero' }  }


  it { expect(runner.run_expectations!(
                  [foo_expectation],
                  program)).to eq [{'expectation' => foo_expectation, 'result' => true}] }

  it { expect(runner.run_expectations!(
                  [bar_expectation],
                  program)).to eq [{'expectation' => bar_expectation, 'result' => false}] }

  it { expect(runner.run_expectations!(
                  [unknown_expectation],
                  program)).to eq [{'expectation' => unknown_expectation, 'result' => false}] }

  it { expect(runner.run_expectations!(
                  [foo],
                  bar)).to eq [{'expectation' => foo, 'result' => true}] }


end
