require 'spec_helper'
require 'yaml'

require_relative '../lib/test_compiler'

describe TestCompiler do
  context '#compile' do
    let(:compiler) { TestCompiler.new }
    let(:test_file) {
'initial_board:
  initial

final_board:
  final'
    }
    let(:output) { compiler.create_compilation_file!(test_file, 'extra', 'content') }
    it { expect(output).to eq({ :source => "content\nextra", :initial_board => 'initial', :final_board => 'final' }) }
  end
end
