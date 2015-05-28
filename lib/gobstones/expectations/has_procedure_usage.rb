require_relative '../with_tempfile'

module Gobstones::Expectations
  class HasProcedureUsage
    include Gobstones::WithTempfile

    def initialize(procedure_name)
      @procedure_name = procedure_name
    end

    def value_for(ast)
      ast.match /AST\(procCall\s*#{@procedure_name}/
    end
  end
end