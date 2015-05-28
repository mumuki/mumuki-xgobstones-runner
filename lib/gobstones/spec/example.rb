module Gobstones::Spec
  class Example
    include Gobstones::WithTempfile
    include Gobstones::WithCommandLine

    attr_reader :language

    def initialize(check_head_position, language)
      @check_head_position = check_head_position
      @language = language
    end

    def start!(source_file, initial_board, final_board)
      @source_file = source_file
      @expected_final_board_gbb = final_board
      @expected_final_board = Gobgems::Gbb.read final_board

      @actual_final_board_file = Tempfile.new %w(gobstones.output .gbb)
      @initial_board_file = write_tempfile initial_board, 'gbb'
      run_command  "#{language.run @source_file, @initial_board_file, @actual_final_board_file} 2>&1"
    end

    def result
      actual_final_board_gbb = @actual_final_board_file.read
      actual_final_board = Gobgems::Gbb.read(actual_final_board_gbb)
      actual_final_board_html = get_html_board(actual_final_board_gbb)

      if matches_with_expected_board? actual_final_board
        passed_result(actual_final_board_html)
      else
        failed_result(actual_final_board_html)
      end
    end

    def parse_error_message(result)
      ErrorMessageParser.new.parse(result)
    end

    def stop!
      [@actual_final_board_file, @initial_board_file].each { |it| it.unlink }
    end

    private

    def failed_result(actual_final_board_html)
      initial_board_html = get_html_board @initial_board_file.open.read
      expected_board_html = get_html_board @expected_final_board_gbb
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


    def matches_with_expected_board?(actual_board)
      actual_board == @expected_final_board && (!@check_head_position || actual_board.head_position == @expected_final_board.head_position)
    end

    def get_html_board(gbb_representation)
      identity = write_tempfile 'program {}', '.gbs'
      board = write_tempfile gbb_representation, '.gbb'
      board_html = Tempfile.new %w(gobstones.board .html)

      %x"#{Language::Gobstones.run(identity, board, board_html)}"

      board_html.read
    ensure
      [identity, board, board_html].compact.each(&:unlink)
    end

    def add_caption(board_html, caption)
      board_html.sub '<table class="gbs_board">', "<table class=\"gbs_board\">\n<caption>#{caption}</caption>"
    end
  end
end
