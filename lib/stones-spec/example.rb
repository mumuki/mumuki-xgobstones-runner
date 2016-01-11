require 'ostruct'

module StonesSpec
  class Example < OpenStruct
    include StonesSpec::WithTempfile
    include StonesSpec::WithCommandLine
    include StonesSpec::WithGbbHtmlRendering

    attr_reader :gobstones_command

    def initialize(subject, attributes, gobstones_command)
      super attributes
      @title = attributes[:title]
      @subject = subject
      @gobstones_command = gobstones_command
    end

    def start!(source, precondition, postcondition)
      @postcondition = postcondition
      @precondition = precondition

      @source_file = write_tempfile @subject.test_program(source, precondition.arguments), source_code_extension

      @actual_final_board_file = Tempfile.new %w(gobstones.output .gbb)
      @initial_board_file = write_tempfile precondition.initial_board_gbb, 'gbb'
      @result, @status = run_command  "#{Language::Gobstones.run(@source_file, @initial_board_file, @actual_final_board_file, gobstones_command)} 2>&1"
    end

    def result
      initial_board_gbb = @initial_board_file.open.read

      if @status == :failed
        error_message = Language::Gobstones.parse_error_message @result
        return [self.title, :failed, make_error_output(error_message, initial_board_gbb)]
      end

      @postcondition.validate(initial_board_gbb, @actual_final_board_file.read, @result)
    end

    def stop!
      [@actual_final_board_file, @initial_board_file].each { |it| it.unlink }
    end

    def title
      @title || default_title
    end

    private

    def source_code_extension
      'gbs'
    end

    def default_title
      @subject.default_title @precondition.arguments
    end

    def make_error_output(error_message, initial_board_gbb)
      if syntax_error?
        raise GobstonesSyntaxError, error_message
      end

      if Language::Gobstones.runtime_error?(error_message)
        "#{get_html_board 'Tablero inicial', initial_board_gbb, gobstones_command}\n#{error_message}"
      else
        error_message
      end
    end

    def syntax_error?
      @result.include_any? ['Error de sintaxis', 'Error en el programa']
    end
  end

  class GobstonesSyntaxError < Exception
  end
end
