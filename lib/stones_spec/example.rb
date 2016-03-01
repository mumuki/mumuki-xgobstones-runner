require 'ostruct'

module StonesSpec
  class Example < OpenStruct
    include StonesSpec::WithTempfile
    include StonesSpec::WithCommandLine

    def initialize(subject, attributes)
      super attributes
      @title = attributes[:title]
      @subject = subject
      @precondition = Precondition.from_example(self)
    end

    def generate_files!(source)
      { source: write_tempfile(@subject.test_program(source, @precondition.arguments), Gobstones.source_code_extension),
        actual_final_board: Tempfile.new(['gobstones.output', Gobstones.board_extension]),
        initial_board: write_tempfile(@precondition.initial_board_gbb, Gobstones.board_extension) }
    end

    def execute!(files)
      result, status = run_command "#{Gobstones.run(files[:source], files[:initial_board], files[:actual_final_board])} 2>&1"
      { result: result, status: status }
    end

    def result(files, execution, postcondition)
      if execution[:status] == :failed
        error_message = Gobstones.parse_error_message execution[:result]
        Gobstones.ensure_no_syntax_error! error_message
      end

      postcondition.validate(files[:initial_board].open.read, files[:actual_final_board].read, execution[:result], execution[:status])
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
