module StonesSpec
  module Subject
    def self.from(string, language)
      if string
        language.infer_subject_type_for(string).new(string)
      else
        Program
      end
    end

    module Program
      def self.test_program(_language, source, _arguments)
        source
      end

      def self.default_title(_language, _source, _arguments)
        nil
      end
    end

    class Procedure
      def initialize(name)
        @name = name
      end

      def test_program(language, source, arguments)
        language.test_procedure(source, @name, arguments)
      end

      def default_title(language, _source, arguments)
        language.procedure_call(@name, arguments)
      end
    end

    class Function
      def initialize(name)
        @name = name
      end

      def test_program(language, source, arguments)
        language.test_function(source, @name, arguments)
      end

      def default_title(language, _source, arguments)
        language.procedure_call(@name, arguments)
      end
    end
  end
end
