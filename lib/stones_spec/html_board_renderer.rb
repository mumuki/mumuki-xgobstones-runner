module StonesSpec
  class HtmlBoardRenderer
    include StonesSpec::WithGbbHtmlRendering

    def render(board)
      get_html_board '', Stones::GbbWriter.write(board)
    end
  end
end