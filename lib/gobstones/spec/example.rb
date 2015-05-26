module Gobstones::Spec
  class Example
    include Gobstones::WithTempfile

    attr_reader :gobstones_path

    def initialize(gobstones_path, check_head_position)
      @gobstones_path = gobstones_path
      @check_head_position = check_head_position
    end

    def start!(source_file, initial_board, final_board)
      @source_file = source_file
      @expected_final_board_gbb = final_board
      @expected_final_board = Gobstones::GbbParser.new.from_string final_board

      @html_output_file = Tempfile.new %w(gobstones.output .html)
      @actual_final_board_file = Tempfile.new %w(gobstones.output .gbb)
      @initial_board_file = write_tempfile initial_board, 'gbb'

      "#{run_on_gobstones @source_file, @initial_board_file, @actual_final_board_file} 2>&1 &&" +
          "#{run_on_gobstones @source_file, @initial_board_file, @html_output_file}"
    end

    def result
      actual = Gobstones::GbbParser.new.from_string(@actual_final_board_file.read)

      if matches_with_expected_board? actual
        ["<div>#{@html_output_file.read}</div>", :passed]
      else
        initial_board_html = get_html_board @initial_board_file.open.read
        expected_board_html = get_html_board @expected_final_board_gbb

        output =
"<div>
  #{add_caption initial_board_html, 'Tablero inicial'}
  #{add_caption @html_output_file.read, 'Tablero final obtenido'}
  #{add_caption expected_board_html, 'Tablero final esperado'}
</div>"

        [output, :failed]
      end
    end

    def parse_error_message(result)
      ErrorMessageParser.new.parse(result)
    end

    def stop!
      [@html_output_file, @actual_final_board_file, @initial_board_file].each { |it| it.unlink }
    end

    private

    def matches_with_expected_board?(actual_board)
      actual_board == @expected_final_board && (!@check_head_position || actual_board.head_position == @expected_final_board.head_position)
    end

    def run_on_gobstones(source_file, initial_board_file, final_board_file)
      "#{gobstones_path} #{source_file.path} --from #{initial_board_file.path} --to #{final_board_file.path}"
    end

    def get_html_board(gbb_representation)
      identity = write_tempfile 'program {}', '.gbs'

      board = write_tempfile gbb_representation, '.gbb'

      board_html = Tempfile.new %w(gobstones.board .html)

      %x"#{run_on_gobstones(identity, board, board_html)}"

      result = board_html.read
      board_html.unlink
      result
    end

    def add_caption(board_html, caption)
      board_html.sub '<table class="gbs_board">', "<table class=\"gbs_board\">\n<caption>#{caption}</caption>"
    end
  end
end
