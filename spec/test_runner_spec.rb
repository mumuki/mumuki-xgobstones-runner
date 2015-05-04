require_relative '../lib/test_runner'

describe TestRunner do
  let(:runner) { TestRunner.new('gobstones_command' => 'python .heroku/vendor/pygobstones/language/vgbs/gbs.py') }
  let(:file) { File.new('spec/data/example.gbs') }

  describe '#run_test_file' do
    describe 'should pass when the file is sintactically ok' do
      let(:results) { runner.run_test_file!(File.new('spec/data/example.gbs')) }  
      it { expect(results[1]).to eq(:passed) }
    end

    describe 'should fail when the file is not sintactically ok' do
      let(:results) { runner.run_test_file!(File.new('spec/data/syntax_error.gbs')) }  
      it { expect(results[1]).to eq(:failed) }
    end    
  end
end