module StonesSpec
  module WithGobstonesCSS
    def gobstones_css(font_size, size)
      unit = 'px'

      full_size = "#{size}#{unit}"
      half_size = "#{size / 2}#{unit}"

    "table.gbs_board {
  border-style: none;
  border: solid black 0px;
  border-spacing: 0;
  border-collapse: collapse;
  font-family: Arial, Helvetica, sans-serif;
  font-size: #{font_size};
  display: inline-block;
  vertical-align: top;
}
.gbs_board td {
  margin: 0;
  padding: 2px;
  border: solid #888 1px;
  width: #{full_size};
  height: #{full_size};
}
.gbs_board td.gh { /* position of the header in the board */
  margin: 0;
  padding: 2px;
  border: dotted #440 3px;
  background: #dd8;
  width: #{full_size};
  height: #{full_size};
}
.gbs_board td.lv { /* labels at the side */
  text-align: center;
  vertical-align: middle;
  border-style: none;
  border: solid black 0px;
  background: #ddd;
  width: #{half_size};
}
.gbs_board td.lh { /* labels at the top / bottom */
  text-align: center;
  vertical-align: middle;
  border-style: none;
  border: solid black 0px;
  background: #ddd;
  height: #{half_size};
}
.gbs_board td.lx { /* corner */
  border-style: none;
  border: solid black 0px;
  background: #ddd;
  width: #{half_size};
  height: #{half_size};
}
.gbs_board td.top_left {
  -webkit-border-top-left-radius: 10px;
  -moz-border-top-left-radius: 10px;
  border-top-left-radius: 10px;
}
.gbs_board td.top_right {
  -webkit-border-top-right-radius: 10px;
  -moz-border-top-right-radius: 10px;
  border-top-right-radius: 10px;
}
.gbs_board td.bottom_left {
  -webkit-border-bottom-left-radius: 10px;
  -moz-border-bottom-left-radius: 10px;
  border-bottom-left-radius: 10px;
}
.gbs_board td.bottom_right {
  -webkit-border-bottom-right-radius: 10px;
  -moz-border-bottom-right-radius: 10px;
  border-bottom-right-radius: 10px;
}
.gbs_board table.gc { /* cell table */
  border-style: none;
  border: solid black 0px;
}
.gbs_board .gc tr {
  border-style: none;
  border: 0px;
}
.gbs_board .gc td {
  border-style: none;
  border: solid black 0px;
  width: #{half_size};
  height: #{half_size};
  text-align: center;
  color: black;
}
.gbs_board .gc td div {
  line-height: 2;
}
.gbs_board div.A { background: #88f; border: solid 1px #008; }
.gbs_board div.N { background: #aaa; border: solid 1px #222; }
.gbs_board div.R { background: #f88; border: solid 1px #800; }
.gbs_board div.V { background: #8f8; border: solid 1px #080; }
.gbs_board div.O { width: 20px; height: 20px; background: none; } /* empty */
.gbs_stone {
  font-weight: bold;
    font-size: 8pt;
    width: 20px;
    height: 20px;
    -webkit-border-radius: 10px;
    -moz-border-radius: 10px;
    border-radius: 10px;
}"
    end
  end
end