module StonesSpec
  module WithGbbHtmlRendering
    def get_html_board(caption, gbb_representation)
      HtmlBoardRenderer.new(caption: caption).render(Stones::GbbReader.new.from_string gbb_representation)
    end

    def make_error_output(result, initial_board_gbb)
      error_message = Gobstones.parse_error_message result
      if Gobstones.runtime_error? error_message
        "#{get_html_board 'Tablero inicial', initial_board_gbb}\n#{get_boom_board initial_board_gbb}\n#{error_message}"
      else
        error_message
      end
    end

    def make_boards_output(title, gbb_boards, status, extra = nil)
      boards = gbb_boards.map { |gbb_with_caption| get_html_board *gbb_with_caption }.join("\n")
      output = "<div>#{boards}</div>"

      output = "<p>#{extra}</p>\n#{output}" if extra

      [title, status, output]
    end

    private

    def get_boom_board(initial_board_gbb)
      gbb = empty_board_gbb_like initial_board_gbb

      boom_css =
        "<style type=\"text/css\">
          table.boom {
            background-image: url('#{boom_image_url}');
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
          }
        </style>"

      without_header with_boom_css_class "#{boom_css}\n#{get_html_board '¡Se produjo BOOM!', gbb}"
    end

    def boom_image_url
      'https://raw.githubusercontent.com/mumuki/mumuki-gobstones-server/master/lib/assets/boom.png'
    end

    def empty_board_gbb_like(initial_board_gbb)
      x, y = Stones::Gbb.read(initial_board_gbb).size
      Stones::Gbb.write Stones::Board.empty(x, y)
    end

    def with_boom_css_class(html)
      html.sub('class="gbs_board"', 'class="gbs_board boom"')
    end

    def without_header(html)
      html.sub('class="gc gh"', 'class="gc"')
    end
  end
end
