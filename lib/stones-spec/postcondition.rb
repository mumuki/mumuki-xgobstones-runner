module StonesSpec
  module Postcondition
    def self.from(example_definition, check_head_position)
      example_definition[:final_board] ?
          FinalBoardPostcondition.new(example_definition[:final_board], check_head_position) :
          ReturnPostcondition.new(example_definition[:return])
    end
  end

  class FinalBoardPostcondition
    include StonesSpec::WithTempfile
    include StonesSpec::WithGbbHtmlRendering

    attr_reader :final_board_gbb, :check_head_position

    def initialize(final_board, check_head_position)
      @final_board_gbb = final_board
      @check_head_position = check_head_position
    end

    def validate(initial_board_gbb, actual_final_board_gbb, _actual_return)
      if matches_with_expected_board? Stones::Gbb.read actual_final_board_gbb
        passed_result initial_board_gbb, actual_final_board_gbb
      else
        failed_result initial_board_gbb, final_board_gbb, actual_final_board_gbb
      end
    end

    private

    def failed_result(initial_board_gbb, expected_board_gbb, actual_board_gbb)
      boards = [
        ['Tablero inicial', initial_board_gbb],
        ['Tablero final esperado', expected_board_gbb],
        ['Tablero final obtenido', actual_board_gbb]
      ]

      make_result boards, :failed
    end

    def passed_result(initial_board_gbb, actual_board_gbb)
      boards = [
        ['Tablero inicial', initial_board_gbb],
        ['Tablero final', actual_board_gbb],
      ]

      make_result boards, :passed
    end

    def make_result(gbb_boards, status)
      output = "<div>#{gbb_boards.map { |gbb_with_caption| caption, board_gbb = *gbb_with_caption
      get_html_board caption, board_gbb }.join("\n")}</div>"
      [output, status]
    end

    def matches_with_expected_board?(actual_board)
      if check_head_position
        actual_board == final_board
      else
        actual_board.cells_equal? final_board
      end
    end

    def final_board
      Stones::Gbb.read final_board_gbb
    end
  end

  class ReturnPostcondition
    attr_reader :return_value

    def initialize(return_value)
      @return_value = return_value.to_s
    end

    def validate(_initial_board_gbb, _actual_final_board_gbb, actual_return)
      normalized_actual_return = actual_return.strip

      if normalized_actual_return == return_value
        ['', :passed]
      else
        ["Se esperaba <b>#{return_value}</b> pero se obtuvo <b>#{normalized_actual_return}</b>"]
      end
    end
  end
end
