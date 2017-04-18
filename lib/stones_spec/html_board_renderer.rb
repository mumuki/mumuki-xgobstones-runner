require_relative './with_gobstones_css'

module StonesSpec
  class HtmlBoardRenderer
    include StonesSpec::WithGobstonesCSS

    def initialize(options = {})
      @options = options
    end

    def render(board)
"<style type=\"text/css\">
#{render_css}</style>

#{render_html board}"
    end

    def method_missing(name)
      @options[name]
    end

    def render_html(board)
      width, height = board.size

"#{table_title}
#{html_row_titles width, 'top'}
#{(0...height).to_a.reverse.map {|y| html_row(board, y)}.join}#{html_row_titles width, 'bottom'}
</table>
"
    end

    def render_css
      gobstones_css '9pt', 30
    end

    private

    def table_title
      base = "<table class=\"gbs_board\">"
      caption ? base + "\n<caption>#{caption}</caption>" : base
    end

    def html_row(board, y)
"  <tr>
    <td class=\"lv\">#{y}</td>
#{(0...board.size[0]).map {|x| html_cell board, [x, y] }.join "\n"}
    <td class=\"lv\">#{y}</td>
  </tr>
"
    end

    def html_cell(board, position)
      cell = board.cell_at position

"    <td class=\"gc#{board.head_position == position ? ' gh' : ''}\">
      <table>
        <tr>#{html_stone cell, :blue}#{html_stone cell, :black}</tr>
        <tr>#{html_stone cell, :red}#{html_stone cell, :green}</tr>
      </table>
    </td>"
    end

    def html_stone(cell, color)
      quantity = cell[color]

      if cell[color] == 0
        '<td><div class="O"></div></td>'
      else
        "<td><div class=\"gbs_stone #{Stones::Color.all_with_names.invert[color][0]}\"><span>#{quantity}</span></div></td>"
      end
    end

    def html_row_titles(width, caption)
"<tr><td class=\"lx #{caption}_left\"></td>#{(0...width).map {|x| "<td class=\"lh\">#{x}</td>"}.join}<td class=\"lx #{caption}_right\"></td></tr>"
    end
  end
end
