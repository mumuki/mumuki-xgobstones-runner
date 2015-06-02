# encoding: UTF-8

require_relative './spec_helper'
require 'yaml'

require_relative '../lib/stones-spec'

include StonesSpec

describe Runner do

end
describe Language::Ruby do
  let(:lang) { Language::Ruby }
  let(:runner) { Runner.new(lang) }
  let(:html) { results[0] }

  context 'when its ok' do
    let(:results) { runner.run!(YAML.load_file 'spec/data/head_position_ok_ruby.yml') }

    it { expect(results[1]).to eq(:passed) }

    it { expect(html).to start_with('<div>') }
    it { expect(html).to end_with('</div>') }
  end


  context 'when its not ok' do
    let(:results) { runner.run!(YAML.load_file 'spec/data/runtime_error_ruby.yml') }

    it { expect(results[1]).to eq(:failed) }

    it { expect(html).to start_with('<pre>') }
    it { expect(html).to end_with('</pre>') }
  end

  context 'when the file is sintactically ok' do
    context 'when the final board matches' do
      let(:results) { runner.run!(YAML.load_file 'spec/data/red_ball_at_origin_ruby.yml') }

      it { expect(results[1]).to eq(:passed) }

      context 'should return an html representation of the board as result' do
        it { expect(html).to include(File.new('spec/data/red_ball_at_origin.html').read) }
        it { expect(html).to start_with('<div>') }
        it { expect(html).to end_with('</div>') }
      end
    end
  end
end
