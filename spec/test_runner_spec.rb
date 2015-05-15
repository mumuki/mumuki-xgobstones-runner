require 'rspec'
require_relative '../lib/test_runner'

describe TestRunner do
  let(:runner) { TestRunner.new('gobstones_command' => 'python .heroku/vendor/pygobstones/language/vgbs/gbs.py') }

  context 'when the file is sintactically ok' do
    context 'and doesnt produce BOOM' do
      let(:results) { runner.run_test_file!(File.new('spec/data/red_ball_at_origin.yml')) }

      it { expect(results[0]).to eq('') }
      it { expect(results[1]).to eq(:passed) }

      context 'should return an html representation of the board as feedback' do
        let(:html) { results[2] }

        it { expect(html).to include(File.new('spec/data/red_ball_at_origin.html').read) }
        it { expect(html).to start_with("<div>") }
        it { expect(html).to end_with("</div>") }
      end
    end

    context 'and produces BOOM' do
      let(:results) { runner.run_test_file!(File.new('spec/data/runtime_error.yml')) }

      it 'should output the error message' do
        expect(results[0]).to eq(
'cerca de invocación a procedimiento
  |
  V
  Mover(Este)

--

Error en tiempo de ejecución:

    No se puede mover el cabezal en dirección: Este
    La posición cae afuera del tablero')
      end

      it 'should fail the test' do
        expect(results[1]).to eq(:failed)
      end
    end
  end

  context 'when the file is not sintactically ok,' do
    let(:results) { runner.run_test_file!(File.new('spec/data/syntax_error.yml')) }

    it 'should output the error message' do
      expect(results[0]).to eq(
'cerca de un identificador con mayúscula "Error"
        |
        V
  Poner(Error)

--

Error en el programa:

    La constante "Error" no está definida')
    end

    it 'should fail the test' do
      expect(results[1]).to eq(:failed)
    end
  end
end