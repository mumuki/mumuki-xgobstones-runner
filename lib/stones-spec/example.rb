require 'ostruct'

module StonesSpec
  class Example < OpenStruct
    include StonesSpec::WithTempfile
    include StonesSpec::WithCommandLine
    include StonesSpec::WithGbbHtmlRendering

    attr_reader :language, :gobstones_command

    def initialize(language, subject, attributes, gobstones_command)
      super attributes
      @title = attributes[:title]
      @language = language
      @subject = subject
      @gobstones_command = gobstones_command
    end

    def start!(source, precondition, postcondition)
      @postcondition = postcondition
      @precondition = precondition

      @source_file = write_tempfile @subject.test_program(language, source, precondition.arguments),
                                    language.source_code_extension

      @actual_final_board_file = Tempfile.new %w(gobstones.output .gbb)
      @initial_board_file = write_tempfile precondition.initial_board_gbb, 'gbb'
      @result, @status = run_command  "#{language.run(@source_file, @initial_board_file, @actual_final_board_file, gobstones_command)} 2>&1"
    end

    def result
      initial_board_gbb = @initial_board_file.open.read

      if @status == :failed
        error_message = language.parse_error_message @result
        return [self.title, make_error_output(error_message, initial_board_gbb), :failed]
      end

      @postcondition.validate(initial_board_gbb, @actual_final_board_file.read, language.parse_success_output(@result))
    end

    def stop!
      [@actual_final_board_file, @initial_board_file].each { |it| it.unlink }
    end

    def title
      @title || default_title
    end

    private

    def default_title
      @subject.default_title language, source, @precondition.arguments
    end

    def make_error_output(error_message, initial_board_gbb)
      if language.is_runtime_error?(@result)
        "#{get_html_board 'Tablero inicial', initial_board_gbb, gobstones_command}\n#{error_message}"
      else
        error_message
      end
    end
  end
end
