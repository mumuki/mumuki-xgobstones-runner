require 'ostruct'

module StonesSpec
  class Example < OpenStruct
    include Mumukit::WithCommandLine

    def initialize(subject, attributes)
      super attributes
      @title = attributes[:title]
      @subject = subject
      @precondition = Precondition.from_example(self)
    end

    def execution_data(source)
      { source: @subject.test_program(source, @precondition.arguments),
        initial_board: @precondition.initial_board_gbb }
    end

    def execute!(files)
      result, status = run_command "#{Gobstones.run(files[:source], files[:initial_board], files[:final_board])} 2>&1"
      { result: result, status: status }
    end

    def result(files, execution, postcondition)
      if execution[:status] == :aborted
        raise Gobstones::AbortedError, execution[:result]
      end

      if execution[:status] == :failed
        error_message = Gobstones.parse_error_message execution[:result]
        Gobstones.ensure_no_syntax_error! error_message
      end

      postcondition.validate(files[:initial_board].open.read, files[:final_board].open.read, execution[:result], execution[:status])
    end

    def title
      @title || default_title
    end

    private

    def default_title
      @subject.default_title @precondition.arguments
    end
  end
end
