require_relative './spec_helper'

include StonesSpec

describe HtmlBoardRenderer do
  let (:gbb) {
'GBB/1.0
size 4 4
cell 0 0 Rojo 1 Verde 2 Azul 5
head 3 3'
  }

  context '#render' do
    let (:expected_html) {
'<style type="text/css">
table.gbs_board {
  border-style: none;
  border: solid black 0px;
  border-spacing: 0;
  border-collapse: collapse;
  font-family: Arial, Helvetica, sans-serif;
  font-size: 9pt;
  display: inline-block;
  vertical-align: top;
}
.gbs_board td {
  margin: 0;
  padding: 2px;
  border: solid #888 1px;
  width: 30px;
  height: 30px;
}
.gbs_board td.gh { /* position of the header in the board */
  margin: 0;
  padding: 2px;
  border: dotted #440 3px;
  background: #dd8;
  width: 30px;
  height: 30px;
}
.gbs_board td.lv { /* labels at the side */
  text-align: center;
  vertical-align: middle;
  border-style: none;
  border: solid black 0px;
  background: #ddd;
  width: 15px;
}
.gbs_board td.lh { /* labels at the top / bottom */
  text-align: center;
  vertical-align: middle;
  border-style: none;
  border: solid black 0px;
  background: #ddd;
  height: 15px;
}
.gbs_board td.lx { /* corner */
  border-style: none;
  border: solid black 0px;
  background: #ddd;
  width: 15px;
  height: 15px;
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
  width: 15px;
  height: 15px;
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
}</style>

<table class="gbs_board">
<tr><td class="lx top_left"></td><td class="lh">0</td><td class="lh">1</td><td class="lh">2</td><td class="lh">3</td><td class="lx top_right"></td></tr>
  <tr>
    <td class="lv">3</td>
    <td class="gc">
      <table>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
      </table>
    </td>
    <td class="gc">
      <table>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
      </table>
    </td>
    <td class="gc">
      <table>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
      </table>
    </td>
    <td class="gc gh">
      <table>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
      </table>
    </td>
    <td class="lv">3</td>
  </tr>
  <tr>
    <td class="lv">2</td>
    <td class="gc">
      <table>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
      </table>
    </td>
    <td class="gc">
      <table>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
      </table>
    </td>
    <td class="gc">
      <table>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
      </table>
    </td>
    <td class="gc">
      <table>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
      </table>
    </td>
    <td class="lv">2</td>
  </tr>
  <tr>
    <td class="lv">1</td>
    <td class="gc">
      <table>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
      </table>
    </td>
    <td class="gc">
      <table>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
      </table>
    </td>
    <td class="gc">
      <table>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
      </table>
    </td>
    <td class="gc">
      <table>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
      </table>
    </td>
    <td class="lv">1</td>
  </tr>
  <tr>
    <td class="lv">0</td>
    <td class="gc">
      <table>
        <tr><td><div class="O"></div></td><td><div class="gbs_stone A"><span>5</span></div></td></tr>
        <tr><td><div class="gbs_stone R"><span>1</span></div></td><td><div class="gbs_stone V"><span>2</span></div></td></tr>
      </table>
    </td>
    <td class="gc">
      <table>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
      </table>
    </td>
    <td class="gc">
      <table>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
      </table>
    </td>
    <td class="gc">
      <table>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
        <tr><td><div class="O"></div></td><td><div class="O"></div></td></tr>
      </table>
    </td>
    <td class="lv">0</td>
  </tr>
<tr><td class="lx bottom_left"></td><td class="lh">0</td><td class="lh">1</td><td class="lh">2</td><td class="lh">3</td><td class="lx bottom_right"></td></tr>
</table>
'
    }

    let(:board) { Stones::GbbReader.new.from_string gbb }

    let(:actual_html) { HtmlBoardRenderer.new(options).render board }

    context 'without options' do
      let (:options) { {} }
      it { expect(actual_html).to eq expected_html }
    end

    context 'with caption' do
      let (:options) { {caption: 'Some caption'} }
      it { expect(actual_html).to include "<table class=\"gbs_board\">\n<caption>Some caption</caption>" }
    end
  end
end
