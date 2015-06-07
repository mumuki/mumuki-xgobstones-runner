module StonesSpec
  module WithGbbHtmlRendering
    def get_html_board(gbb_representation)
      identity = write_tempfile 'program {}', '.gbs'
      board = write_tempfile gbb_representation, '.gbb'
      board_html = Tempfile.new %w(gobstones.board .html)

      %x"#{Language::Gobstones.run(identity, board, board_html)}"

      board_html.read
    ensure
      [identity, board, board_html].compact.each(&:unlink)
    end
  end
end
