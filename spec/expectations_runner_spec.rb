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

  context 'HasUsage expectation' do
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

  context 'HasWhile expectation' do
    let(:has_while_expectation) { {'binding' => 'program', 'inspection' => 'HasWhile'} }

    it { expect(runner.run_expectations!([has_while_expectation], 'program {}'))
             .to eq [{'expectation' => has_while_expectation, 'result' => false}] }

    let(:program_with_while) { '
      program {
        i := 3
        while(i > 0) {
          Mover(Oeste)
          i := i - 1
        }
      }
    ' }

    it { expect(runner.run_expectations!([has_while_expectation], program_with_while))
             .to eq [{'expectation' => has_while_expectation, 'result' => true}] }
  end

  context 'HasRepeatOf:n expectation' do
    let(:has_repeat_of_1_expectation) { {'binding' => 'program', 'inspection' => 'HasRepeatOf:1'} }

    let(:program_with_repeat_1) { '
      program {
        repeat(1) {
          Mover(Oeste)
        }
      }
    ' }

    let(:program_with_repeat_8) { '
      program {
        repeat(8) {
          Mover(Oeste)
        }
      }
    ' }

    let(:program_without_repeat) { '
      program {
        Mover(Oeste)
      }
    ' }

    it { expect(runner.run_expectations!([has_repeat_of_1_expectation], program_with_repeat_1))
             .to eq [{'expectation' => has_repeat_of_1_expectation, 'result' => true}] }

    it { expect(runner.run_expectations!([has_repeat_of_1_expectation], program_with_repeat_8))
             .to eq [{'expectation' => has_repeat_of_1_expectation, 'result' => false}] }

    it { expect(runner.run_expectations!([has_repeat_of_1_expectation], program_without_repeat))
             .to eq [{'expectation' => has_repeat_of_1_expectation, 'result' => false}] }
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
