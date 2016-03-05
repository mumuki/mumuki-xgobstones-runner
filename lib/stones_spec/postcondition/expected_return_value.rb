module StonesSpec
  module Postcondition
    class ExpectedReturnValue < ExpectedResult
      def initialize(example, show_initial_board)
        super example
        @show_initial_board = show_initial_board
      end

      def validate_expected_result(initial_board_gbb, _actual_final_board_gbb, result)
        normalized_actual_return = parse_success_output(result).strip

        if normalized_actual_return == return_value
          make_result(:passed, initial_board_gbb)
        else
          make_result(:failed, initial_board_gbb, "Se esperaba <b>#{return_value}</b> pero se obtuvo <b>#{normalized_actual_return}</b>")
        end
      end

      private

      def parse_success_output(result)
        first_return_value result || ''
      end

      def first_return_value(result)
        result[/#1 -> (.+)/, 1]
      end

      def make_result(status, initial_board_gbb, output='')
        title = "#{example.title} -> #{return_value}"

        if @show_initial_board
          make_boards_output title, [['Tablero inicial', initial_board_gbb]], status, output
        else
          [title, status, output]
        end
      end

      def return_value
        example.return.to_s
      end
    end
  end
end