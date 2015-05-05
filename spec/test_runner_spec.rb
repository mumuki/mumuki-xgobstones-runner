require_relative '../lib/test_runner'

describe TestRunner do
  let(:runner) { TestRunner.new('gobstones_command' => 'python .heroku/vendor/pygobstones/language/vgbs/gbs.py') }

  describe '#run_test_file' do
    describe 'when the file is sintactically ok,' do
      let(:results) { runner.run_test_file!(File.new('spec/data/red_ball_at_origin.gbs')) }  
      
      it 'should output the board as html' do
        expect(results[0]).to include(File.new('spec/data/red_ball_at_origin.html').read) 
      end

      it 'should pass the test' do
        expect(results[1]).to eq(:passed) 
      end
    end

    describe 'should fail when the file is not sintactically ok' do
      let(:results) { runner.run_test_file!(File.new('spec/data/syntax_error.gbs')) }  
      it { expect(results[1]).to eq(:failed) }
    end    
  end
end