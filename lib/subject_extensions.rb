module StonesSpec::Subject
  class Procedure
    def ast_regexp
      /AST\(procedure\s*#{@name}/
    end
  end

  class Function
    def ast_regexp
      /AST\(function\s*#{@name}/
    end
  end

  module Program
    def self.ast_regexp
      /AST\(entrypoint\s*program/
    end
  end
end