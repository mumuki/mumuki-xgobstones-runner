require_relative 'board'

class GbbParser
  def parseString(gbb_string)
    board = nil

    lines = gbb_string.lines

    /size (\d+) (\d+)/.match(lines[1]) { |data| board = Board.new(data[1].to_i, data[2].to_i) }

    board
  end
end