module StonesSpec
  module Subject
    def self.from(name)
      if name
        infer_subject_type_for(name).new(name)
      else
        Program
      end
    end

    def self.infer_subject_type_for(string)
      string.start_with_lowercase? ? StonesSpec::Subject::Function : StonesSpec::Subject::Procedure
    end

    module Callable
      def procedure_call(arguments)
        "#{@name}(#{arguments.join(', ')})"
      end
    end

    module Program
      def self.test_program(source, _arguments)
        source
      end

      def self.default_title(_arguments)
        nil
      end
    end

    class Procedure
      include Callable

      def initialize(name)
        @name = name
      end

      def test_program(source, arguments)
        "program {
          #{procedure_call arguments}
        }

        #{source}"
      end

      def default_title(arguments)
        procedure_call arguments
      end
    end

    class Function
      include Callable

      def initialize(name)
        @name = name
      end

      def test_program(source, arguments)
        "program {
          return (#{procedure_call arguments})
        }

        #{source}"
      end

      def default_title(arguments)
        procedure_call arguments
      end
    end
  end
end
