require_relative 'spec_helper'

describe GobstonesExpectationsHook do
  def req(expectations, content)
    struct expectations: expectations, content: content
  end

  def compile_and_run(request)
    runner.run!(runner.compile(request))
  end

  let(:runner) { GobstonesExpectationsHook.new(mulang_path: './bin/mulang') }
  let(:result) { compile_and_run(req(expectations, code)) }

  describe 'HasTooShortBindings' do
    let(:code) { %q{
      function f(x) {
        return (g(x))
      }} }
    let(:expectations) { [] }

    it { expect(result).to eq [{expectation: {binding: 'f', inspection: 'HasTooShortBindings'}, result: false}] }
  end

  describe 'HasWrongCaseBindings' do
    let(:code) { "function a_function_with_bad_case() { return (3) }" }
    let(:expectations) { [] }

    it { expect(result).to eq [{expectation: {binding: 'a_function_with_bad_case', inspection: 'HasWrongCaseBindings'}, result: false}] }
  end

  describe 'HasRedundantIf' do
    let(:code) { %q{
      function foo(x) {
        y := x
        if (x) {
          y := True
        } else {
          y := False
        }
        return (y)
      } } }
    let(:expectations) { [] }

    it do
      pending "not ready until mulang 2.2"
      expect(result).to eq [{expectation: {binding: 'foo', inspection: 'HasRedundantIf'}, result: false}]
    end
  end

  describe 'HasRedundantLocalVariableReturn' do
    let(:code) { %q{
      function foo(x) {
        y := x + 3
        return (y)
      } } }
    let(:expectations) { [] }

    it { expect(result).to eq [{expectation: {binding: 'foo', inspection: 'HasRedundantLocalVariableReturn'}, result: false}] }
  end


  describe 'DeclaresProcedure' do
    let(:code) { "procedure Foo(x, y) { }\nprogram { bar := 4 }" }
    let(:expectations) { [
      {binding: '', inspection: 'DeclaresProcedure:Foo'},
      {binding: '', inspection: 'DeclaresProcedure:bar'},
      {binding: '', inspection: 'DeclaresProcedure:baz'}] }

    it { expect(result).to eq [
        {expectation: expectations[0], result: true},
        {expectation: expectations[1], result: false},
        {expectation: expectations[2], result: false}] }
  end


  describe 'DeclaresFunction' do
    let(:code) { "function foo(x, y) { return (x + y); }\nprogram { bar := 4 }" }
    let(:expectations) { [
      {binding: '', inspection: 'DeclaresFunction:foo'},
      {binding: '', inspection: 'DeclaresFunction:bar'},
      {binding: '', inspection: 'DeclaresFunction:baz'}] }

    it { expect(result).to eq [
        {expectation: expectations[0], result: true},
        {expectation: expectations[1], result: false},
        {expectation: expectations[2], result: false}] }
  end

  describe 'DeclaresVariable' do
    let(:code) { "procedure Foo(x, y) { }\nprogram { bar := 4 }" }
    let(:expectations) { [
      {binding: '', inspection: 'DeclaresVariable:Foo'},
      {binding: '', inspection: 'DeclaresVariable:bar'},
      {binding: '', inspection: 'DeclaresVariable:baz'}] }

    it { expect(result).to eq [
        {expectation: expectations[0], result: false},
        {expectation: expectations[1], result: true},
        {expectation: expectations[2], result: false}] }
  end

  describe 'Declares' do
    let(:code) { "function foo(x, y) { return(x) }\nprocedure Bar(x) { }" }
    let(:expectations) { [
      {binding: '', inspection: 'Declares:foo'},
      {binding: '', inspection: 'Declares:Bar'},
      {binding: '', inspection: 'Declares:baz'}] }

    it { expect(result).to eq [
        {expectation: expectations[0], result: true},
        {expectation: expectations[1], result: true},
        {expectation: expectations[2], result: false}] }
  end

  context 'HasWhile expectation' do
    let(:code) { %q{
      program {
        i := 3
        while(i > 0) {
          Mover(Oeste)
          i := i - 1
        }
      } } }

    let(:expectations) { [{'binding' => 'program', 'inspection' => 'HasWhile'}] }

    it { expect(result).to eq [{expectation: {'binding' => '', 'inspection' => 'UsesWhile'}, result: true}] }
  end

  describe 'HasUsage expectation' do
    context 'when the parameter is a procedure' do
      let(:code) { 'program { Foo() } procedure Foo() {}' }

      let(:expectations) { [
        {'binding' => 'program', 'inspection' => 'HasUsage:Foo'},
        {'binding' => 'program', 'inspection' => 'HasUsage:Bar'},
        {'binding' => 'program', 'inspection' => 'HasUsage:FooBar'},
        {'binding' => 'program', 'inspection' => 'HasUsage:BarFoo'},
        {'binding' => 'program', 'inspection' => 'HasUsage:Fo'} ] }

      it { expect(result).to eq [
          {expectation: {inspection: 'Uses:=Foo', binding: ''}, result: true},
          {expectation: {inspection: 'Uses:=Bar', binding: ''}, result: false},
          {expectation: {inspection: 'Uses:=FooBar', binding: ''}, result: false},
          {expectation: {inspection: 'Uses:=BarFoo', binding: ''}, result: false},
          {expectation: {inspection: 'Uses:=Fo', binding: ''}, result: false}] }
    end

    context 'when the parameter is a function' do
      let(:code) { 'program { return (foo()) } function foo() { return (2) }' }

      let(:expectations) { [
        {'binding' => 'program', 'inspection' => 'HasUsage:foo'},
        {'binding' => 'program', 'inspection' => 'HasUsage:bar'},
        {'binding' => 'program', 'inspection' => 'HasUsage:fooBar'},
        {'binding' => 'program', 'inspection' => 'HasUsage:barFoo'},
        {'binding' => 'program', 'inspection' => 'HasUsage:fo'} ] }

      it { expect(result).to eq [
          {expectation: {inspection: 'Uses:=foo', binding: ''}, result: true},
          {expectation: {inspection: 'Uses:=bar', binding: ''}, result: false},
          {expectation: {inspection: 'Uses:=fooBar', binding: ''}, result: false},
          {expectation: {inspection: 'Uses:=barFoo', binding: ''}, result: false},
          {expectation: {inspection: 'Uses:=fo', binding: ''}, result: false}] }
    end

    context 'when the program is empty' do
      let(:code) { '' }

      let(:expectations) { [{'binding' => 'program', 'inspection' => 'HasUsage:Sacar' }]  }

      it { expect { result }.to raise_error Mumukit::CompilationError }
    end
  end
end


=begin





describe GobstonesExpectationsHook do



  context 'HasVariable expectation' do
    let(:has_variable_expectation) { {'binding' => 'program', 'inspection' => 'HasVariable'} }

    it { expect('program {}').not_to comply_with has_variable_expectation }

    let(:program_with_variable) { '
      program {
        acum := 25
      }
    ' }

    it { expect(program_with_variable).to comply_with has_variable_expectation }
  end

  context 'HasForeach expectation' do
    let(:has_foreach_expectation) { {'binding' => 'program', 'inspection' => 'HasForeach'} }

    it { expect('program {}').not_to comply_with has_foreach_expectation }

    let(:program_with_foreach) { '
      program {
        foreach color in [Azul..Verde] {
          Poner(color)
        }
      }
    ' }

    it { expect(program_with_foreach).to comply_with has_foreach_expectation }
  end


  context 'HasRepedatOf:n expectation' do
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
                        function otraCosa(x, y) { return (Verde) }' }

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

      let(:result) { runner.run! content: program, expectations: [], test: 'dummy: true' }

      it { expect(result).to eq [{ 'expectation' => has_binding_program, 'result' => true }] }
    end

    context 'when the subject is a procedure' do
      let(:procedure) { 'procedure Dummy() {}' }
      let(:not_has_binding_program) { {'binding' => 'program', 'inspection' => 'Not:HasBinding' }  }
      let(:has_binding_procedure) { {'binding' => 'Dummy', 'inspection' => 'HasBinding' }  }

      let(:result) { runner.run! content: procedure, expectations: [], test: 'subject: Dummy' }

      it { expect(result).to include({ 'expectation' => not_has_binding_program, 'result' => true }) }
      it { expect(result).to include({ 'expectation' => has_binding_procedure, 'result' => true }) }
    end

    context 'when the subject is a function' do
      let(:function) { 'function dummy() { return(25) }' }
      let(:not_has_binding_program) { {'binding' => 'program', 'inspection' => 'Not:HasBinding' }  }
      let(:has_binding_function) { {'binding' => 'dummy', 'inspection' => 'HasBinding' }  }

      let(:result) { runner.run! content: function, expectations: [], test: 'subject: dummy' }

      it { expect(result).to include({ 'expectation' => not_has_binding_program, 'result' => true }) }
      it { expect(result).to include({ 'expectation' => has_binding_function, 'result' => true }) }
    end
  end


end

=end
