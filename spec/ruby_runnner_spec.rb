# encoding: UTF-8

require_relative './spec_helper'
require 'yaml'

require_relative '../lib/stones-spec'

include StonesSpec

describe Runner do

end
describe Language::Ruby do
  let(:lang) { Language::Ruby }
  let(:command) { 'python .heroku/vendor/pygobstones-lang/pygobstoneslang.py' }
  let(:runner) { Runner.new(lang, command) }
  let(:html) { results[0][1] }


  describe 'procedure spec' do
    context 'when passes' do
      let(:results) { runner.run!(YAML.load_file 'spec/data/ruby/procedure/move_to_origin_ok.yml') }

      it { expect(all_examples :passed).to be true }
    end

    context 'when passes with arguments' do
      let(:results) { runner.run!(YAML.load_file 'spec/data/ruby/procedure/times_move_ok.yml') }

      it { expect(all_examples :passed).to be true }
    end

    context 'when fails' do
      let(:results) { runner.run!(YAML.load_file 'spec/data/ruby/procedure/move_to_origin_fail.yml') }

      it { expect(all_examples :failed).to be true  }
    end

    context 'when fails with arguments' do
      let(:results) { runner.run!(YAML.load_file 'spec/data/ruby/procedure/times_move_fail.yml') }

      it { expect(all_examples :failed).to be true }
    end
  end

  describe 'function spec' do
    context 'when passes with args' do
      let(:results) { runner.run!(YAML.load_file 'spec/data/ruby/function/remaining_cells_ok.yml') }

      it {expect(all_examples :passed).to be true }
    end

    context 'when fails with args' do
      let(:results) { runner.run!(YAML.load_file 'spec/data/ruby/function/remaining_cells_fail.yml') }

      it { expect(results[0][2] ).to eq :failed }
      it { expect(html).to eq 'Se esperaba <b>9</b> pero se obtuvo <b>18</b>' }
    end
  end

  context 'when its ok' do
    let(:results) { runner.run!(YAML.load_file 'spec/data/head_position_ok_ruby.yml') }

    it { expect(all_examples :passed).to be true }

    it { expect(html).to start_with('<div>') }
    it { expect(html).to end_with('</div>') }
  end

  describe 'program spec' do
    context 'when head falls out of board' do
      let(:results) { runner.run!(YAML.load_file 'spec/data/runtime_error_ruby.yml') }

      it { expect(all_examples :failed).to be true }

      it { expect(html).to include(File.new('spec/data/runtime_error_initial.html').read) }
      it { expect(html).to end_with('</pre>') }
    end

    context 'when no stones are available for popping' do
      let(:results) { runner.run!(YAML.load_file 'spec/data/runtime_error_pop_ruby.yml') }

      it { expect(all_examples :failed).to be true }

      it { expect(html).to include(File.new('spec/data/runtime_error_initial.html').read) }
      it { expect(html).to end_with('</pre>') }
    end

    context 'when the file is sintactically ok' do
      context 'when the final board matches' do
        let(:results) { runner.run!(YAML.load_file 'spec/data/red_ball_at_origin_ruby.yml') }

        it { expect(all_examples :passed).to be true }

        context 'should return an html representation of the initial and final board as result' do
          it { expect(html).to include(File.new('spec/data/red_ball_at_origin_initial.html').read) }
          it { expect(html).to include(File.new('spec/data/red_ball_at_origin.html').read) }
          it { expect(html).to start_with('<div>') }
          it { expect(html).to end_with('</div>') }
        end
      end
    end
    context 'when the file is not sintactically ok' do
      context 'should return an unstructured output' do
        let(:results) { runner.run!(YAML.load_file 'spec/data/syntax_error_ruby.yml') }
        it { expect(results[1]).to eql :failed }
        it { expect(results[0]).to include 'SyntaxError' }
      end
    end
  end

  def all_examples status
    results.all? {|result| result[2].eql? status}
  end
end