require_relative './spec_helper'

require_relative '../lib/expectations_runner'


describe ExpectationsRunner do
  let(:runner) { ExpectationsRunner.new }
  let(:program) { 'program { Foo() } procedure Foo() {}' }

  let(:foo_expectation) { {'binding' => 'program', 'inspection' => 'HasUsage:Foo'} }
  let(:bar_expectation) { {'binding' => 'program', 'inspection' => 'HasUsage:Bar'} }
  let(:unknown_expectation) { {'binding' => 'program', 'inspection' => 'HasBinding'} }

  it { expect(runner.run_expectations!(
                  [foo_expectation],
                  program)).to eq [{'expectation' => foo_expectation, 'result' => true}] }

  it { expect(runner.run_expectations!(
                  [bar_expectation],
                  program)).to eq [{'expectation' => bar_expectation, 'result' => false}] }

  it { expect(runner.run_expectations!(
                  [unknown_expectation],
                  program)).to eq [{'expectation' => unknown_expectation, 'result' => false}] }

  context 'when extra code is provided' do
    let(:program_with_extra_code) { 'program { DibujarMacetero(Rojo) }' }
    let(:extra_code) { 'procedure DibujarMacetero(color) { Poner(color) }' }
    let(:has_usage_expectation) { {'binding' => 'program', 'inspection' => 'HasUsage:DibujarMacetero' }  }

    it { expect(runner.run_expectations!(
                  [has_usage_expectation],
                  program_with_extra_code,
                  extra_code)).to eq [{'expectation' => has_usage_expectation, 'result' => true}] }

  end
end
