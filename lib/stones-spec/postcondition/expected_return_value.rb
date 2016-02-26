module StonesSpec
  module Postcondition
    class ExpectedReturnValue < ExpectedResult
      def validate_expected_result(_initial_board_gbb, _actual_final_board_gbb, result)
        normalized_actual_return = parse_success_output(result).strip

        if normalized_actual_return == return_value
          make_result(:passed)
        else
          make_result(:failed, "Se esperaba <b>#{return_value}</b> pero se obtuvo <b>#{normalized_actual_return}</b>")
        end
      end

      private

      def parse_success_output(result)
        first_return_value result || ''
      end

      def first_return_value(result)
        result[/#1 -> (.+)/, 1]
      end

      def make_result(status, output='')
        ["#{example.title} -> #{return_value}", status, output]
      end

      def return_value
        example.return.to_s
      end
    end
  end
end