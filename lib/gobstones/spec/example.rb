module Gobstones::Spec
  class Example
    include Gobstones::WithTempfile

    attr_reader :gobstones_path

    def initialize(gobstones_path)
      @gobstones_path = gobstones_path
    end

    def start!(source, initial_board, final_board)
      @expected_final_board_gbb = final_board
      @expected_final_board = Gobstones::GbbParser.new.from_string final_board

      @html_output_file = Tempfile.new %w(gobstones.output .html)
      @actual_final_board_file = Tempfile.new %w(gobstones.output .gbb)
      @source_file = write_tempfile source, 'gbs'
      @initial_board_file = write_tempfile initial_board, 'gbb'

      "#{run_on_gobstones @source_file, @initial_board_file, @actual_final_board_file} 2>&1 &&" +
          "#{run_on_gobstones @source_file, @initial_board_file, @html_output_file}"
    end

    def result
      actual = Gobstones::GbbParser.new.from_string(@actual_final_board_file.read)

      if actual == @expected_final_board
        ["<div>#{@html_output_file.read}</div>", :passed]
      else
        initial_board = get_html_board @initial_board_file.open.read
        expected_board = get_html_board @expected_final_board_gbb

        output =
"<div>
  <b>Tablero inicial</b> #{initial_board}
  <b>Tablero final obtenido</b> #{@html_output_file.read}
  <b>Tablero final esperado</b> #{expected_board}
</div>"

        [output, :failed]
      end
    end


    def parse_error_message(result)
      ErrorMessageParser.new.parse(result)
    end

    def stop!
      [@html_output_file, @actual_final_board_file, @source_file, @initial_board_file].each { |it| it.unlink }
    end

    private

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
  end

end
