require_relative '../with_tempfile'

module Gobstones::Expectations
  class HasProcedureUsage
    include Gobstones::WithTempfile

    def initialize(source_code, procedure_name)
      @source_code = source_code
      @procedure_name = procedure_name
    end

    def value
      get_ast.match /AST\(procCall\s*#{@procedure_name}/
    end

    private

    def get_ast
      %x"gbs #{write_tempfile(@source_code, 'gbs').path} --print-ast --no-print-board --no-print-retvals"
    end
  end
end