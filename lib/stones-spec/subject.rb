module StonesSpec
  module Subject
    def self.from(string)
      string ? Procedure.new(string) : Program
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
        language.test_program(source, @name, arguments)
      end
    end
  end


end
