module StonesSpec
  class Example
    include StonesSpec::WithTempfile
    include StonesSpec::WithCommandLine
    include StonesSpec::WithGbbHtmlRendering

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

      actual_final_board_gbb = @actual_final_board_file.read
      actual_final_board = Stones::Gbb.read(actual_final_board_gbb)
      actual_final_board_html = get_html_board(actual_final_board_gbb)

      if @postcondition.matches_with_expected_board? actual_final_board
        passed_result(actual_final_board_html)
      else
        failed_result(actual_final_board_html)
      end
    end

    def stop!
      [@actual_final_board_file, @initial_board_file].each { |it| it.unlink }
    end

    private

    def failed_result(actual_final_board_html)
      initial_board_html = get_html_board @initial_board_file.open.read
      expected_board_html = get_html_board @postcondition.final_board_gbb
      output =
"<div>
  #{add_caption initial_board_html, 'Tablero inicial'}
  #{add_caption actual_final_board_html, 'Tablero final obtenido'}
  #{add_caption expected_board_html, 'Tablero final esperado'}
</div>"
      [output, :failed]
    end

    def passed_result(actual_final_board_html)
      ["<div>#{actual_final_board_html}</div>", :passed]
    end


    def add_caption(board_html, caption)
      board_html.sub '<table class="gbs_board">', "<table class=\"gbs_board\">\n<caption>#{caption}</caption>"
    end
  end
end
