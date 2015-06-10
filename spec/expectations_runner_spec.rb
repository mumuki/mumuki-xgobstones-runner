require_relative './spec_helper'

require_relative '../lib/expectations_runner'


describe ExpectationsRunner do
  let(:runner) { ExpectationsRunner.new }

  context 'Unknown expectation' do
    let(:program) { 'program { Foo() } procedure Foo() {}' }
    let(:unknown_expectation) { {'binding' => 'program', 'inspection' => 'HasBinding'} }

    it { expect(runner.run_expectations!(
                  [unknown_expectation],
                  program)).to eq [{'expectation' => unknown_expectation, 'result' => false}] }
  end

  context 'HasUsage' do
    let(:program) { 'program { Foo() } procedure Foo() {}' }

    let(:foo_expectation) { {'binding' => 'program', 'inspection' => 'HasUsage:Foo'} }
    let(:bar_expectation) { {'binding' => 'program', 'inspection' => 'HasUsage:Bar'} }

    it { expect(runner.run_expectations!(
                    [foo_expectation],
                    program)).to eq [{'expectation' => foo_expectation, 'result' => true}] }

    it { expect(runner.run_expectations!(
                    [bar_expectation],
                    program)).to eq [{'expectation' => bar_expectation, 'result' => false}] }
  end

  context 'when procedure definitions are missing' do
    let(:program_with_extra_code) { 'procedure DibujarJardin() { DibujarMacetero(Rojo) }' }
    let(:has_usage_expectation) { {'binding' => 'DibujarJardin', 'inspection' => 'HasUsage:DibujarMacetero' }  }

    it { expect(runner.run_expectations!(
                  [has_usage_expectation],
                  program_with_extra_code)).to eq [{'expectation' => has_usage_expectation, 'result' => true}] }

  end

  context 'when the code would produce a runtime error' do
    let(:program_with_extra_code) { 'program { Sacar(Rojo) }' }
    let(:has_usage_expectation) { {'binding' => 'program', 'inspection' => 'HasUsage:Sacar' }  }

    it { expect(runner.run_expectations!(
                    [has_usage_expectation],
                    program_with_extra_code)).to eq [{'expectation' => has_usage_expectation, 'result' => true}] }

  end
end
