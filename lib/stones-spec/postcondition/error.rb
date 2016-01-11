module StonesSpec
  module Postcondition
    class Error
      include StonesSpec::WithGbbHtmlRendering

      attr_reader :example

      def initialize(example)
        @example = example
      end

      def validate(initial_board_gbb, _actual_final_board_gbb, result, status)
        [example.title, :passed, make_error_output(result, initial_board_gbb)]
      end
    end
  end
end