module StonesSpec
  class Example
    include StonesSpec::WithTempfile
    include StonesSpec::WithCommandLine

    attr_reader :language

    def initialize(language, subject)
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
      if @status == :failed
        return [language.parse_error_message(@result), :failed]
      end
      @postcondition.validate(@initial_board_file, @actual_final_board_file.read, @result)
    end

    def stop!
      [@actual_final_board_file, @initial_board_file].each { |it| it.unlink }
    end
  end
end
