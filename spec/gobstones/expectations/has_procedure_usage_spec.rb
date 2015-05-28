require 'rspec'

require_relative '../../../lib/gobstones'

include Gobstones::Expectations

describe HasProcedureUsage do
  context '#value' do
    it { expect(HasProcedureUsage.new('program { IrAlBorde(Oeste) }', 'IrAlBorde').value).to be_true }
    it { expect(HasProcedureUsage.new('program { IrAlBorde(Oeste) }', 'Mover').value).to be_false }
  end
end