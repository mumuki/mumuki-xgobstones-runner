module StonesSpec
  class Example
    include StonesSpec::WithTempfile
    include StonesSpec::WithCommandLine
    include StonesSpec::WithGbbHtmlRendering

    attr_reader :language

    def initialize(title, language, subject)
      @title = title
      @language = language
      @subject = subject
    end

    def start!(source, precondition, postcondition)
      @postcondition = postcondition

      @source_file = write_tempfile @subject.test_program(language, source, precondition.arguments),
                                    language.source_code_extension

      @actual_final_board_file = Tempfile.new %w(gobstones.output .gbb)
      @initial_board_file = write_tempfile precondition.initial_board_gbb, 'gbb'
      @result, @status = run_command  "#{language.run @source_file, @initial_board_file, @actual_final_board_file} 2>&1"
    end

    def result
      initial_board_gbb = @initial_board_file.open.read

      if @status == :failed
        error_message = language.parse_error_message @result
        return [make_error_output(error_message, initial_board_gbb), :failed]
      end

      @postcondition.validate(initial_board_gbb, @actual_final_board_file.read, language.parse_success_output(@result))
    end

    def stop!
      [@actual_final_board_file, @initial_board_file].each { |it| it.unlink }
    end

    private

    def make_error_output(error_message, initial_board_gbb)
      if language.is_runtime_error?(@result)
        with_title @title, "#{get_html_board 'Tablero inicial', initial_board_gbb}\n#{error_message}"
      else
        error_message
      end
    end
  end
end
