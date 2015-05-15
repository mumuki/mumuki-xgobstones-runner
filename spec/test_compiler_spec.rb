require 'rspec'
require 'yaml'

require_relative '../lib/test_compiler'

describe TestCompiler do
  context '#compile' do
    let(:compiler) { TestCompiler.new }

    it 'should return a hash' do
      expect(YAML::load compiler.compile('test', 'extra', 'content')).to eq({ :source => "content\nextra", :initial_board => 'test' })
    end
  end
end