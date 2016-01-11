module StonesSpec
  module Postcondition
    class ExpectedFinalBoard < ExpectedResult
      include StonesSpec::WithTempfile
      include StonesSpec::WithGbbHtmlRendering

      attr_reader :check_head_position, :show_initial_board

      def initialize(example, check_head_position, show_initial_board)
        super example
        @check_head_position = check_head_position
        @show_initial_board = show_initial_board
      end

      def validate_expected_result(initial_board_gbb, actual_final_board_gbb, _result)
        if matches_with_expected_board? Stones::Gbb.read actual_final_board_gbb
          passed_result initial_board_gbb, actual_final_board_gbb
        else
          failed_result initial_board_gbb, example.final_board, actual_final_board_gbb
        end
      end

      private

      def failed_result(initial_board_gbb, expected_board_gbb, actual_board_gbb)
        boards = [
            ['Tablero final esperado', expected_board_gbb],
            ['Tablero final obtenido', actual_board_gbb]
        ]

        boards.unshift ['Tablero inicial', initial_board_gbb] if show_initial_board

        make_boards_output example.title, boards, :failed
      end

      def passed_result(initial_board_gbb, actual_board_gbb)
        boards = [
            ['Tablero final', actual_board_gbb]
        ]

        boards.unshift ['Tablero inicial', initial_board_gbb] if show_initial_board

        make_boards_output example.title, boards, :passed
      end

      def matches_with_expected_board?(actual_board)
        if check_head_position
          actual_board == final_board
        else
          actual_board.cells_equal? final_board
        end
      end

      def final_board
        Stones::Gbb.read example.final_board
      end
    end
  end
end