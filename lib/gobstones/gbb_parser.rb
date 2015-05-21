require_relative '../extensions/array.rb'


class MatchData
  def to_position
    Gobstones::Position.new self[1].to_i, self[2].to_i
  end
end

module Gobstones
  class GbbParser
    COLORS = {'Azul' => :blue, 'Negro' => :black, 'Rojo' => :red, 'Verde' => :green}

    def from_string(gbb_string)
      board = nil

      lines = gbb_string.lines.reject { |it| it.start_with? 'GBB', '%%' }

      /size (\d+) (\d+)/.match(lines[0]) { |match| board = Board.new(match[1].to_i, match[2].to_i) }
      /head (\d+) (\d+)/.match(lines.last) { |match| board.move_head_to match.to_position }

      lines.drop(1).init.each do |cell_line|
        position = get_position_from cell_line
        cell = create_cell_from cell_line

        board.add_cell position, cell
      end

      board
    end

    private

    def get_position_from(cell_line)
      /cell (\d+) (\d+)/.match(cell_line).to_position
    end

    def create_cell_from(cell_line)
      cell = Cell.new

      cell_line.scan(/(Azul|Negro|Rojo|Verde) (\d+)/) do |match|
        cell.set to_color(match[0]), match[1].to_i
      end

      cell
    end

    def to_color(gbb_color_string)
      COLORS[gbb_color_string]
    end
  end
end
