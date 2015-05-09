require_relative '../lib/test_runner'

describe TestRunner do
  let(:runner) { TestRunner.new('gobstones_command' => 'python .heroku/vendor/pygobstones/language/vgbs/gbs.py') }

  describe '#run_test_file' do
    describe 'when the file is sintactically ok' do
      describe 'and doesnt produce BOOM' do
        let(:results) { runner.run_test_file!(File.new('spec/data/red_ball_at_origin.gbs')) }

        it { expect(results[0]).to eq('') }
        
        it 'should pass the test' do
          expect(results[1]).to eq(:passed)
        end
        
        it 'should return an html representation of the board as feedback' do
          expect(results[2]).to include(File.new('spec/data/red_ball_at_origin.html').read)
        end
      end

      describe 'and produces BOOM' do
        let(:results) { runner.run_test_file!(File.new('spec/data/runtime_error.gbs')) }

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

    describe 'when the file is not sintactically ok,' do
      let(:results) { runner.run_test_file!(File.new('spec/data/syntax_error.gbs')) }

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
end