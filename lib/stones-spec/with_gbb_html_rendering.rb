module StonesSpec
  module WithGbbHtmlRendering
    def get_html_board(caption, gbb_representation, gobstones_command)
      identity = write_tempfile 'program {}', '.gbs'
      board = write_tempfile gbb_representation, '.gbb'
      board_html = Tempfile.new %w(gobstones.board .html)

      %x"#{Gobstones.run(identity, board, board_html, gobstones_command)}"

      with_caption caption, board_html.read
    ensure
      [identity, board, board_html].compact.each(&:unlink)
    end

    private

    def with_caption(caption, board_html)
      board_html.sub '<table class="gbs_board">', "<table class=\"gbs_board\">\n<caption>#{caption}</caption>"
    end
  end
end
