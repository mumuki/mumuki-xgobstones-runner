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

    let(:expectations) { [{binding: 'program', inspection: 'HasWhile'}] }

    it { expect(result).to eq [{expectation: {binding: 'program', inspection: 'UsesWhile'}, result: true}] }
  end

  context 'HasVariable expectation' do
    let(:code) { %q{
      program {
        acum := 25
    }} }

    let(:expectations) { [
      {'binding' => 'program', 'inspection' => 'DeclaresVariable'},
      {'binding' => 'foo', 'inspection' => 'DeclaresVariable'}] }

    it { expect(result).to eq [
          {expectation: {inspection: 'DeclaresVariable', binding: 'program'}, result: true},
          {expectation: {inspection: 'DeclaresVariable', binding: 'foo'}, result: false}] }
  end

  context 'HasForeach expectation' do
    let(:expectations) { [
      {'binding' => 'program', 'inspection' => 'HasForeach'},
      {'binding' => 'foo', 'inspection' => 'HasForeach'}] }

    let(:code) { %q{
      program {
        foreach color in [Azul..Verde] {
          Poner(color)
        }
      }
      function foo(){
        return (1)
      }}}

    it {
      pending "foreach is not yet supported by gobstones web"
      expect(result).to eq [
          {expectation: {inspection: 'UsesForeach', binding: 'program'}, result: true},
          {expectation: {inspection: 'UsesForeach', binding: 'foo'}, result: false}] }
  end

  context 'HasArity:n expectation' do
    context 'when the binding is a procedure' do
      let(:code) { 'procedure MoverN(n, direccion) { repeat(n) { Mover(direccion) } }
                    procedure MoverNSarasa(direccion) { Mover(direccion) }
                    procedure SarasaMoverN() { repeat(1) {} }' }
      let(:expectations) { [
        {'binding' => 'MoverN', 'inspection' => 'HasArity:0' },
        {'binding' => 'MoverN', 'inspection' => 'HasArity:1' },
        {'binding' => 'MoverN', 'inspection' => 'HasArity:2' } ] }

      it { expect(result).to eq [
            {expectation: {inspection: 'DeclaresComputationWithArity0:=MoverN', binding: ''}, result: false},
            {expectation: {inspection: 'DeclaresComputationWithArity1:=MoverN', binding: ''}, result: false},
            {expectation: {inspection: 'DeclaresComputationWithArity2:=MoverN', binding: ''}, result: true}] }
    end

    context 'when the binding is a function' do
      let(:code) { 'function colorDestacado() { return (Rojo) }
                    function otraCosa(x, y) { return (Verde) }' }

      let(:expectations) { [
        {'binding' => 'colorDestacado', 'inspection' => 'HasArity:0' },
        {'binding' => 'colorDestacado', 'inspection' => 'HasArity:2' }] }

      it { expect(result).to eq [
          {expectation: {inspection: 'DeclaresComputationWithArity0:=colorDestacado', binding: ''}, result: true},
          {expectation: {inspection: 'DeclaresComputationWithArity2:=colorDestacado', binding: ''}, result: false} ] }
    end
  end

  describe 'HasRepeat expectation' do
    let(:expectations) { [{'binding' => 'program', 'inspection' => 'HasRepeat'}] }

    context 'program has repeat' do
      let(:code) { %q{
        program {
          repeat(6) {
            Mover(Oeste)
          }
        } } }
      it { expect(result).to eq [{expectation: {inspection: 'UsesRepeat', binding: 'program'}, result: true}] }
    end

    context 'program has no repeat' do
      let(:code) { %q{
        program {
          Mover(Oeste)
        }
      } }
      it { expect(result).to eq [{expectation: {inspection: 'UsesRepeat', binding: 'program'}, result: false}] }
    end

    context 'program has repeat with expression' do
      let(:code) { %q{
        program {
          repeat(10 * 2) {
            Mover(Oeste)
          }
        }
      } }
      it { expect(result).to eq [{expectation: {inspection: 'UsesRepeat', binding: 'program'}, result: true}] }
    end
  end

  context 'HasBinding expectation' do
    context 'when the binding is program' do
      let(:code) { %q{
      program {}
      function dummy() { return(Negro) }
      procedure Dummy() {}} }

      let(:expectations) { [
        {'binding' => 'program', 'inspection' => 'HasBinding' },
        {'binding' => 'dummy', 'inspection' => 'HasBinding' },
        {'binding' => 'Dummy', 'inspection' => 'HasBinding' },
        {'binding' => 'foo', 'inspection' => 'HasBinding' }] }

      it { expect(result).to eq [
          {expectation: {inspection: 'Declares:=program', binding: ''}, result: true},
          {expectation: {inspection: 'Declares:=dummy',   binding: ''}, result: true},
          {expectation: {inspection: 'Declares:=Dummy',   binding: ''}, result: true},
          {expectation: {inspection: 'Declares:=foo',     binding: ''}, result: false}
        ] }
    end
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
          {expectation: {inspection: 'Uses:=Foo', binding: 'program'}, result: true},
          {expectation: {inspection: 'Uses:=Bar', binding: 'program'}, result: false},
          {expectation: {inspection: 'Uses:=FooBar', binding: 'program'}, result: false},
          {expectation: {inspection: 'Uses:=BarFoo', binding: 'program'}, result: false},
          {expectation: {inspection: 'Uses:=Fo', binding: 'program'}, result: false}] }
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
