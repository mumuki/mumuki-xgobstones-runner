module StonesSpec
  module Postcondition
    def self.from(example, check_head_position, show_initial_board)
      if example.final_board
        FinalBoard.new(example, check_head_position, show_initial_board)
      elsif example.return
        Return.new(example)
      else
        Error.new(example)
      end
    end

    class Errorable
      include StonesSpec::WithGbbHtmlRendering

      attr_reader :example

      def initialize(example)
        @example = example
      end

      def validate(initial_board_gbb, actual_final_board_gbb, result, status)
        if status == :failed
          [example.title, :failed, make_error_output(result, initial_board_gbb)]
        else
          do_validate(initial_board_gbb, actual_final_board_gbb, result)
        end
      end
    end
  end
end

require_relative './error'
require_relative './final_board'
require_relative './return'
