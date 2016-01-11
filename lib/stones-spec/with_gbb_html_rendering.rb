module StonesSpec
  module WithGbbHtmlRendering
    include StonesSpec::WithTempfile

    def get_html_board(caption, gbb_representation)
      identity = write_tempfile 'program {}', '.gbs'
      board = write_tempfile gbb_representation, '.gbb'
      board_html = Tempfile.new %w(gobstones.board .html)

      %x"#{Gobstones.run(identity, board, board_html)}"

      with_caption caption, board_html.read
    ensure
      [identity, board, board_html].compact.each(&:unlink)
    end

    def make_error_output(result, initial_board_gbb)
      error_message = Gobstones.parse_error_message result
      if Gobstones.runtime_error? error_message
        "#{get_html_board 'Tablero inicial', initial_board_gbb}\n#{error_message}"
      else
        error_message
      end
    end

    private

    def with_caption(caption, board_html)
      board_html.sub '<table class="gbs_board">', "<table class=\"gbs_board\">\n<caption>#{caption}</caption>"
    end
  end
end
