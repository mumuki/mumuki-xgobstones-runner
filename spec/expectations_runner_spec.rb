require_relative './spec_helper'
require_relative '../lib/expectations_runner'
require 'yaml'

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
  let (:config) { YAML.load_file('config/development.yml') }
  let(:runner) { ExpectationsRunner.new(config) }

  context 'Unknown expectation' do
    let(:program) { 'program { Foo() } procedure Foo() {}' }
    let(:unknown_expectation) { {'binding' => 'program', 'inspection' => 'HasSarasa'} }

    it { expect(program).to comply_with unknown_expectation }
  end

  context 'HasUsage expectation' do
    describe 'when the parameter is a procedure' do
      let(:program) { 'program { Foo() } procedure Foo() {}' }

      let(:foo_expectation) { {'binding' => 'program', 'inspection' => 'HasUsage:Foo'} }
      let(:bar_expectation) { {'binding' => 'program', 'inspection' => 'HasUsage:Bar'} }
      let(:foo_bar_expectation) { {'binding' => 'program', 'inspection' => 'HasUsage:FooBar'} }
      let(:bar_foo_expectation) { {'binding' => 'program', 'inspection' => 'HasUsage:BarFoo'} }
      let(:fo_expectation) { {'binding' => 'program', 'inspection' => 'HasUsage:Fo'} }

      it { expect(program).to comply_with foo_expectation }
      it { expect(program).not_to comply_with bar_expectation }
      it { expect(program).not_to comply_with foo_bar_expectation }
      it { expect(program).not_to comply_with bar_foo_expectation }
      it { expect(program).not_to comply_with fo_expectation }
    end

    describe 'when the parameter is a function' do
      let(:program) { 'program { return (foo()) } function foo() { return (2) }' }

      let(:foo_expectation) { {'binding' => 'program', 'inspection' => 'HasUsage:foo'} }
      let(:bar_expectation) { {'binding' => 'program', 'inspection' => 'HasUsage:bar'} }
      let(:foo_bar_expectation) { {'binding' => 'program', 'inspection' => 'HasUsage:fooBar'} }
      let(:bar_foo_expectation) { {'binding' => 'program', 'inspection' => 'HasUsage:barFoo'} }
      let(:fo_expectation) { {'binding' => 'program', 'inspection' => 'HasUsage:fo'} }

      it { expect(program).to comply_with foo_expectation }
      it { expect(program).not_to comply_with bar_expectation }
      it { expect(program).not_to comply_with foo_bar_expectation }
      it { expect(program).not_to comply_with bar_foo_expectation }
      it { expect(program).not_to comply_with fo_expectation }
    end
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

  context 'HasRepeat expectation' do
    let(:has_repeat_expectation) { {'binding' => 'program', 'inspection' => 'HasRepeat'} }

    let(:program_with_repeat) { '
      program {
        repeat(6) {
          Mover(Oeste)
        }
      }
    ' }

    let(:program_without_repeat) { '
      program {
        Mover(Oeste)
      }
    ' }

    let(:program_with_repeat_using_an_expression) { '
      program {
        repeat(10 * 2) {
          Mover(Oeste)
        }
      }
    ' }

    it { expect(program_with_repeat).to comply_with has_repeat_expectation }
    it { expect(program_without_repeat).not_to comply_with has_repeat_expectation }
    it { expect(program_with_repeat_using_an_expression).to comply_with has_repeat_expectation }
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
      let(:procedure_Dum) { 'procedure Dum() {}' }
      let(:procedure_DummySarasa) { 'procedure DummySarasa() {}' }
      let(:procedure_SarasaDummy) { 'procedure SarasaDummy() {}' }

      it { expect(program).not_to comply_with has_binding_procedure_expectation }
      it { expect(procedure_Dum).not_to comply_with has_binding_procedure_expectation }
      it { expect(procedure_DummySarasa).not_to comply_with has_binding_procedure_expectation }
      it { expect(procedure_SarasaDummy).not_to comply_with has_binding_procedure_expectation }
      it { expect(procedure).to comply_with has_binding_procedure_expectation }
      it { expect(function).not_to comply_with has_binding_procedure_expectation }
    end

    context 'when the binding is a function' do
      let(:has_binding_function_expectation) { {'binding' => 'dummy', 'inspection' => 'HasBinding' }  }
      let(:function_dum) { 'function dum() { return(Negro) }' }
      let(:function_dum_sarasa) { 'function dum_sarasa() { return(Negro) }' }
      let(:function_sarasa_dum) { 'function sarasa_dum() { return(Negro) }' }

      it { expect(procedure).not_to comply_with has_binding_function_expectation }
      it { expect(program).not_to comply_with has_binding_function_expectation }
      it { expect(function).to comply_with has_binding_function_expectation }
      it { expect(function_dum).not_to comply_with has_binding_function_expectation }
      it { expect(function_dum_sarasa).not_to comply_with has_binding_function_expectation }
      it { expect(function_sarasa_dum).not_to comply_with has_binding_function_expectation }
    end
  end

  context 'HasArity:n expectation' do
    context 'when the binding is a procedure' do
      let(:procedure) { 'procedure MoverN(n, direccion) { repeat(n) { Mover(direccion) } }
                         procedure MoverNSarasa(direccion) { Mover(direccion) }
                         procedure SarasaMoverN() { repeat(1) {} }' }
      let(:has_arity_0) { {'binding' => 'MoverN', 'inspection' => 'HasArity:0' }  }
      let(:has_arity_1) { {'binding' => 'MoverN', 'inspection' => 'HasArity:1' }  }
      let(:has_arity_2) { {'binding' => 'MoverN', 'inspection' => 'HasArity:2' }  }

      it { expect(procedure).to comply_with has_arity_2 }
      it { expect(procedure).not_to comply_with has_arity_1 }
      it { expect(procedure).not_to comply_with has_arity_0 }
    end

    context 'when the binding is a function' do
      let(:function) { 'function colorDestacado() { return (Rojo) }
                        function color() { return (Rojo) }
                        function colorDestacado() { return (Rojo) }' }

      let(:has_arity_0) { {'binding' => 'colorDestacado', 'inspection' => 'HasArity:0' }  }
      let(:has_arity_1) { {'binding' => 'colorDestacado', 'inspection' => 'HasArity:1' }  }
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

    context 'when the subject is a procedure' do
      let(:procedure) { 'procedure Dummy() {}' }
      let(:not_has_binding_program) { {'binding' => 'program', 'inspection' => 'Not:HasBinding' }  }
      let(:has_binding_procedure) { {'binding' => 'Dummy', 'inspection' => 'HasBinding' }  }

      let(:result) { runner.run_expectations! content: procedure, expectations: [], test: 'subject: Dummy' }

      it { expect(result).to include({ 'expectation' => not_has_binding_program, 'result' => true }) }
      it { expect(result).to include({ 'expectation' => has_binding_procedure, 'result' => true }) }
    end

    context 'when the subject is a function' do
      let(:function) { 'function dummy() { return(25) }' }
      let(:not_has_binding_program) { {'binding' => 'program', 'inspection' => 'Not:HasBinding' }  }
      let(:has_binding_function) { {'binding' => 'dummy', 'inspection' => 'HasBinding' }  }

      let(:result) { runner.run_expectations! content: function, expectations: [], test: 'subject: dummy' }

      it { expect(result).to include({ 'expectation' => not_has_binding_program, 'result' => true }) }
      it { expect(result).to include({ 'expectation' => has_binding_function, 'result' => true }) }
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
