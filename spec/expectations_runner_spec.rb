require_relative './spec_helper'
require_relative '../lib/expectations_runner'

require 'rspec/expectations'

RSpec::Matchers.define :comply_with do |expectation|
  match_for_should do |code|
    run_expectation! code, true
  end

  match_for_should_not do |code|
    run_expectation! code, false
  end

  define_method :run_expectation! do |code, expected_result|
    runner.run_expectations!(expectations: [expectation], content: code, test: 'dummy: true').include?({'expectation' => expectation, 'result' => expected_result})
  end
end

describe ExpectationsRunner do
  let(:runner) { ExpectationsRunner.new }

  context 'Unknown expectation' do
    let(:program) { 'program { Foo() } procedure Foo() {}' }
    let(:unknown_expectation) { {'binding' => 'program', 'inspection' => 'HasSarasa'} }

    it { expect(program).to comply_with unknown_expectation }
  end

  context 'HasUsage expectation' do
    let(:program) { 'program { Foo() } procedure Foo() {}' }

    let(:foo_expectation) { {'binding' => 'program', 'inspection' => 'HasUsage:Foo'} }
    let(:bar_expectation) { {'binding' => 'program', 'inspection' => 'HasUsage:Bar'} }

    it { expect(program).to comply_with foo_expectation }
    it { expect(program).not_to comply_with bar_expectation }
  end

  context 'HasWhile expectation' do
    let(:has_while_expectation) { {'binding' => 'program', 'inspection' => 'HasWhile'} }

    it { expect('program {}').not_to comply_with has_while_expectation }

    let(:program_with_while) { '
      program {
        i := 3
        while(i > 0) {
          Mover(Oeste)
          i := i - 1
        }
      }
    ' }

    it { expect(program_with_while).to comply_with has_while_expectation }
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

    it { expect(program_with_repeat_1).to comply_with has_repeat_of_1_expectation }
    it { expect(program_with_repeat_8).not_to comply_with has_repeat_of_1_expectation }
    it { expect('program { Mover(Oeste) }').not_to comply_with has_repeat_of_1_expectation }
  end

  context 'HasBinding expectation' do
    let(:program) { 'program {}' }
    let(:procedure) { 'procedure Dummy() {}' }
    let(:function) { 'function dummy() { return(Negro) }' }

    context 'when the binding is program' do
      let(:has_binding_program_expectation) { {'binding' => 'program', 'inspection' => 'HasBinding' }  }

      it { expect(program).to comply_with has_binding_program_expectation }
      it { expect(procedure).not_to comply_with has_binding_program_expectation }
      it { expect(function).not_to comply_with has_binding_program_expectation }
    end

    context 'when the binding is a procedure' do
      let(:has_binding_procedure_expectation) { {'binding' => 'Dummy', 'inspection' => 'HasBinding' }  }

      it { expect(program).not_to comply_with has_binding_procedure_expectation }
      it { expect(procedure).to comply_with has_binding_procedure_expectation }
      it { expect(function).not_to comply_with has_binding_procedure_expectation }
    end

    context 'when the binding is a function' do
      let(:has_binding_function_expectation) { {'binding' => 'dummy', 'inspection' => 'HasBinding' }  }

      it { expect(procedure).not_to comply_with has_binding_function_expectation }
      it { expect(program).not_to comply_with has_binding_function_expectation }
      it { expect(function).to comply_with has_binding_function_expectation }
    end
  end

  context 'HasArity:n expectation' do
    context 'when the binding is a procedure' do
      let(:procedure) { 'procedure MoverN(n, direccion) { repeat(n) { Mover(direccion) } }' }
      let(:has_arity_1) { {'binding' => 'MoverN', 'inspection' => 'HasArity:1' }  }
      let(:has_arity_2) { {'binding' => 'MoverN', 'inspection' => 'HasArity:2' }  }

      it { expect(procedure).to comply_with has_arity_2 }
      it { expect(procedure).not_to comply_with has_arity_1 }
    end

    context 'when the binding is a program' do
      let(:function) { 'function colorDestacado() { return (Rojo) }' }
      let(:has_arity_0) { {'binding' => 'colorDestacado', 'inspection' => 'HasArity:0' }  }
      let(:has_arity_2) { {'binding' => 'colorDestacado', 'inspection' => 'HasArity:2' }  }

      it { expect(function).to comply_with has_arity_0 }
      it { expect(function).not_to comply_with has_arity_2 }
    end
  end

  describe 'automatic expectations' do
    context 'when the subject is program' do
      let(:program) { 'program {}' }
      let(:has_binding_program) { {'binding' => 'program', 'inspection' => 'HasBinding' }  }

      let(:result) { runner.run_expectations! content: program, expectations: [], test: 'dummy: true' }

      it { expect(result).to eq [{ 'expectation' => has_binding_program, 'result' => true }] }
    end
  end

  context 'when procedure definitions are missing' do
    let(:program_with_extra_code) { 'procedure DibujarJardin() { DibujarMacetero(Rojo) }' }
    let(:has_usage_expectation) { {'binding' => 'DibujarJardin', 'inspection' => 'HasUsage:DibujarMacetero' }  }

    it { expect(program_with_extra_code).to comply_with has_usage_expectation }
  end

  context 'when the code would produce a runtime error' do
    let(:has_usage_expectation) { {'binding' => 'program', 'inspection' => 'HasUsage:Sacar' }  }

    it { expect('program { Sacar(Rojo) }').to comply_with has_usage_expectation }
  end

  context 'when the program is empty' do
    let(:has_usage_expectation) { {'binding' => 'program', 'inspection' => 'HasUsage:Sacar' }  }

    it { expect('').not_to comply_with has_usage_expectation }
  end
end
