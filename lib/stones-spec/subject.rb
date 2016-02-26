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

    module Program
      def self.test_program(source, _arguments)
        source
      end

      def self.default_title(_arguments)
        nil
      end
    end

    class Callable
      def initialize(name)
        @name = name
      end

      def call_string(arguments)
        "#{@name}(#{arguments.join(', ')})"
      end

      def default_title(arguments)
        call_string arguments
      end
    end

    class Procedure < Callable
      def test_program(source, arguments)
        "program {
          #{call_string arguments}
        }

        #{source}"
      end
    end

    class Function < Callable
      def test_program(source, arguments)
        "program {
          return (#{call_string arguments})
        }

        #{source}"
      end
    end
  end
end
