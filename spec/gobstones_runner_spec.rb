# encoding: UTF-8

require_relative './spec_helper'
require 'yaml'

require_relative '../lib/stones-spec'

include StonesSpec

describe Runner do
  describe Language::Gobstones do
    let(:lang) { Language::Gobstones }
    let(:runner) { Runner.new(lang) }
    let(:test_definition) { YAML.load_file "spec/data/#{test_file}.yml" }
    let(:results) { runner.run! test_definition }
    let(:html) { results[0] }
    let(:status) { results[1] }

    describe 'procedure spec' do
      context 'when passes' do
        let(:test_file) { 'gobstones/procedure/move_to_origin_ok' }
        it { expect(status).to eq :passed }
      end

      context 'when passes with arguments' do
        let(:test_file) { 'gobstones/procedure/times_move_ok' }
        it { expect(status).to eq :passed }
      end

      context 'when fails' do
        let(:test_file) { 'gobstones/procedure/move_to_origin_fail' }
        it { expect(status).to eq :failed }
      end

      context 'when fails with arguments' do
        let(:test_file) { 'gobstones/procedure/times_move_fail' }
        it { expect(status).to eq :failed }
      end
    end

    describe 'function spec' do
      context 'when passes with args' do
        let(:test_file) { 'gobstones/function/remaining_cells_ok' }
        it { expect(status).to eq :passed }
      end

      context 'when fails with args' do
        let(:test_file) { 'gobstones/function/remaining_cells_fail' }

        it { expect(status).to eq :failed }
        it { expect(html).to eq 'Se esperaba <b>9</b> pero se obtuvo <b>18</b>' }
      end
    end

    describe 'program spec' do
      context 'when the program is empty' do
        let(:test_file) { 'empty_program' }
        it { expect(html).to include 'No es posible ejecutar un programa vacío' }
      end

      context 'can check head position' do
        context 'when its wrong' do
          let(:test_file) { 'head_position_wrong' }
          it { expect(status).to eq(:failed) }
        end

        context 'when its ok' do
          let(:test_file) { 'head_position_ok' }
          it { expect(status).to eq(:passed) }
        end
      end

      context 'when a title is given' do
        context 'and the test passes' do
          let(:test_file) { 'red_ball_at_origin' }
          it { expect(html).to include '<h3>A red ball</h3>' }
        end

        context 'and the test fails' do
          let(:test_file) { 'red_ball_at_origin_wrong' }
          it { expect(html).to include '<h3>A red ball</h3>' }
        end

        context 'and syntax errors are present' do
          let(:test_file) { 'syntax_error' }
          it { expect(html).not_to include '<h3>A syntax error</h3>' }
        end

        context 'and a runtime error occurs' do
          let(:test_file) { 'runtime_error' }
          it { expect(html).to include '<h3>A runtime error</h3>' }
        end
      end

      context 'when a title is not given' do
        context 'and the test passes' do
          let(:test_file) { 'red_ball_at_origin_without_title' }
          it { expect(html).not_to include '<h3></h3>' }
        end

        context 'and a runtime error occurs' do
          let(:test_file) { 'runtime_error_without_title' }
          it { expect(html).not_to include '<h3></h3>' }
        end
      end

      context 'doesnt check head position if the flag is false' do
        let(:test_file) { 'dont_check_head_position' }
        it { expect(status).to eq(:passed) }
      end

      context 'doesnt include the initial board if the flag is false' do
        let(:test_file) { 'red_ball_at_origin_without_initial_board' }
        it { expect(html).not_to include(File.new('spec/data/red_ball_at_origin_initial.html').read) }
      end

      context 'when the file is sintactically ok' do
        context 'when the final board matches' do
          let(:test_file) { 'red_ball_at_origin' }

          it { expect(status).to eq(:passed) }

          context 'should return an html representation of the initial and final board as result' do
            it { expect(html).to include(File.new('spec/data/red_ball_at_origin_initial.html').read) }
            it { expect(html).to include(File.new('spec/data/red_ball_at_origin.html').read) }
            it { expect(html).to start_with('<div>') }
            it { expect(html).to end_with('</div>') }
          end
        end

        context 'when the final board doesnt match' do
          let(:test_file) { 'red_ball_at_origin_wrong' }
          it { expect(status).to eq(:failed) }

          context 'should return an html representation of the initial, expected and actual boards as result' do
            it { expect(html).to include(File.new('spec/data/red_ball_at_origin_initial.html').read) }
            it { expect(html).to include(File.new('spec/data/red_ball_at_origin_wrong.html').read) }
            it { expect(html).to include(File.new('spec/data/red_ball_at_origin_expected.html').read) }
            it { expect(html).to start_with('<div>') }
            it { expect(html).to end_with('</div>') }
          end
        end

        context 'when produces BOOM' do
          let(:test_file) { 'runtime_error' }

          it { expect(status).to eq(:failed) }

          it { expect(html).to include(File.new('spec/data/runtime_error_initial.html').read) }
          it do
            expect(html).to include(
'<pre>cerca de invocación a procedimiento
  |
  V
  Mover(Este)

--

Error en tiempo de ejecución:

    No se puede mover el cabezal en dirección: Este
    La posición cae afuera del tablero</pre>')
          end
        end
      end

      context 'when the file is not sintactically ok,' do
        let(:test_file) { 'syntax_error' }

        it { expect(status).to eq(:failed) }
        it do
          expect(html).to eq(
'<pre>cerca de un identificador con mayúscula "Error"
        |
        V
  Poner(Error)

--

Error en el programa:

    El tipo Error no está definido</pre>')
        end
      end
    end
  end
end
