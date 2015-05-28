module Gobstones::Expectations
  class HasProcedureUsage
    def initialize(source_code, procedure_name)
      @source_code = source_code
      @procedure_name = procedure_name
    end

    def value
      @procedure_name == 'IrAlBorde'
    end
  end
end