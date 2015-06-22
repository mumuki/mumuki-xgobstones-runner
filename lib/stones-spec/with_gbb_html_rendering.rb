module StonesSpec
  module WithGbbHtmlRendering
    def get_html_board(caption, gbb_representation)
      identity = write_tempfile 'program {}', '.gbs'
      board = write_tempfile gbb_representation, '.gbb'
      board_html = Tempfile.new %w(gobstones.board .html)

      %x"#{Language::Gobstones.run(identity, board, board_html)}"

      with_caption caption, board_html.read
    ensure
      [identity, board, board_html].compact.each(&:unlink)
    end

    def with_title(example, title, html)
      effective_title = title || example.default_title

      if effective_title
        "<h3>#{effective_title}</h3>#{html}"
      else
        html
      end
    end

    private

    def with_caption(caption, board_html)
      board_html.sub '<table class="gbs_board">', "<table class=\"gbs_board\">\n<caption>#{caption}</caption>"
    end
  end
end
