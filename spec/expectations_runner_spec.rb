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

end
