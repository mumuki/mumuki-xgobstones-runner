module WithDefaultExpectations
  def default_expectations
    [{ 'binding' => 'program', 'inspection' => 'Not:HasBinding' }, { 'binding' => "#{@name}", 'inspection' => 'HasBinding' }]
  end
end

module StonesSpec::Subject
  class Procedure
    include WithDefaultExpectations

    def ast_regexp
      /AST\(procedure\s*#{@name}/
    end
  end

  class Function
    include WithDefaultExpectations

    def ast_regexp
      /AST\(function\s*#{@name}/
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