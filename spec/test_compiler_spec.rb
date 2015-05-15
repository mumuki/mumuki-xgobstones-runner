require 'rspec'
require_relative '../lib/test_compiler'

describe TestCompiler do
  context '#compile' do
    let(:compiler) { TestCompiler.new }

    it 'should return a hash' do
      expect(compiler.compile('test', 'extra', 'content')).to eq({ :source => "content\nextra", :initial_board => 'test' })
    end
  end
end