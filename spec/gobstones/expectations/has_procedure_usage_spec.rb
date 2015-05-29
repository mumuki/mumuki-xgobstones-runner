require 'rspec'

require_relative '../../../lib/gobstones'

include Gobstones::Expectations

describe HasProcedureUsage do
  context '#value' do
    let(:runner) { ExpectationsRunner.new('python .heroku/vendor/pygobstones/language/vgbs/gbs.py', 'program { IrAlBorde(Oeste) }') }
    let(:results) { runner.run! [HasProcedureUsage.new('IrAlBorde'), HasProcedureUsage.new('Mover')] }
    it { expect(results.first[1]).to be_true }
    it { expect(results.last[1]).to be_false }
  end
end