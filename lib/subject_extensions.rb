module StonesSpec::Subject
  class Procedure
    def ast_regexp
      /AST\(procedure\s*#{@name}/
    end

    def default_expectations
      [{ 'binding' => 'program', 'inspection' => 'Not:HasBinding' }, { 'binding' => "#{@name}", 'inspection' => 'HasBinding' }]
    end
  end

  class Function
    def ast_regexp
      /AST\(function\s*#{@name}/
    end

    def default_expectations
      []
    end
  end

  module Program
    def self.ast_regexp
      /AST\(entrypoint\s*program/
    end

    def self.default_expectations
      [{ 'binding' => 'program', 'inspection' => 'HasBinding' }]
    end
  end
end