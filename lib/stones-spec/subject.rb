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
      def self.test_program(language, source, arguments)
        source
      end
    end

    class Procedure
      def initialize(name)
        @name = name
      end

      def test_program(language, source, arguments)
        language.test_procedure(source, @name, arguments)
      end
    end

    class Function
      def initialize(name)
        @name = name
      end

      def test_program(language, source, arguments)
        language.test_function(source, @name, arguments)
      end
    end
  end
end
