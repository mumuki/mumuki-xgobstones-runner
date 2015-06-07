class String
  def start_with_lowercase?
    first_letter = self[0]
    first_letter.downcase == first_letter
  end
end

module StonesSpec
  module Subject
    def self.from(string)
      if string
        string.start_with_lowercase? ? Function.new(string) : Procedure.new(string)
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
