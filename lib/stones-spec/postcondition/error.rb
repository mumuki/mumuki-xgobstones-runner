module StonesSpec
  module Postcondition
    class Error
      include StonesSpec::WithGbbHtmlRendering

      attr_reader :example

      def initialize(example)
        @example = example
      end

      def validate(initial_board_gbb, actual_final_board_gbb, result, status)
        if status == :failed
          [example.title, :passed, make_error_output(result, initial_board_gbb)]
        else
          boards = [['Tablero inicial', initial_board_gbb], ['Tablero final', actual_final_board_gbb]]
          make_boards_output example.title, boards, :failed, failure_message
        end
      end

      private

      def failure_message
        'Se esperaba que el programa hiciera BOOM pero se obtuvo un tablero final.'
      end
    end
  end
end