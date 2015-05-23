require 'spec_helper'
require 'yaml'

require_relative '../lib/gobstones'

include Gobstones::Spec

describe Runner do
  let(:runner) { Runner.new('python .heroku/vendor/pygobstones/language/vgbs/gbs.py') }

  context 'when the file is sintactically ok' do
    context 'when the final board matches' do
      let(:results) { runner.run!(YAML.load_file 'spec/data/red_ball_at_origin.yml') }

      it { expect(results[1]).to eq(:passed) }

      context 'should return an html representation of the board as result' do
        let(:html) { results[0] }

        it { expect(html).to include(File.new('spec/data/red_ball_at_origin.html').read) }
        it { expect(html).to start_with('<div>') }
        it { expect(html).to end_with('</div>') }
      end
    end

    context 'when the final board doesnt match' do
      let(:results) { runner.run!(YAML.load_file 'spec/data/red_ball_at_origin_wrong.yml') }
      it { expect(results[1]).to eq(:failed) }

      context 'should return an html representation of the initial, expected and actual boards as result' do
        let(:html) { results[0] }

        it { expect(html).to include(File.new('spec/data/red_ball_at_origin_initial.html').read) }
        it { expect(html).to include(File.new('spec/data/red_ball_at_origin_wrong.html').read) }
        it { expect(html).to include(File.new('spec/data/red_ball_at_origin_expected.html').read) }
        it { expect(html).to start_with('<div>') }
        it { expect(html).to end_with('</div>') }
      end
    end

    context 'when produces BOOM' do
      let(:results) { runner.run!(YAML.load_file 'spec/data/runtime_error.yml') }
      it { expect(results[1]).to eq(:failed) }
      it do
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
    end
  end

  context 'when the file is not sintactically ok,' do
    let(:results) { runner.run!(YAML.load_file 'spec/data/syntax_error.yml') }
    it { expect(results[1]).to eq(:failed) }
    it do
      expect(results[0]).to eq(
'cerca de un identificador con mayúscula "Error"
        |
        V
  Poner(Error)

--

Error en el programa:

    La constante "Error" no está definida')
    end
  end
end
