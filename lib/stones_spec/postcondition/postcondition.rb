module StonesSpec
  module Postcondition
    def self.from(example, check_head_position, show_initial_board)
      if example.final_board
        ExpectedFinalBoard.new(example, check_head_position, show_initial_board)
      elsif example.return
        ExpectedReturnValue.new(example)
      else
        ExpectedBoom.new(example)
      end
    end

    class ExpectedResult
      include StonesSpec::WithGbbHtmlRendering

      attr_reader :example

      def initialize(example)
        @example = example
      end

      def validate(initial_board_gbb, actual_final_board_gbb, result, status)
        if status == :failed
          [example.title, :failed, make_error_output(result, initial_board_gbb)]
        else
          validate_expected_result(initial_board_gbb, actual_final_board_gbb, result)
        end
      end
    end
  end
end

require_relative './expected_boom'
require_relative './expected_final_board'
require_relative './expected_return_value'
