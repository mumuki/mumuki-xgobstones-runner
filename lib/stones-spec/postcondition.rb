module StonesSpec
  module Postcondition
    def self.from(example_definition, check_head_position)
      example_definition[:final_board] ?
          FinalBoardPostcondition.new(example_definition[:final_board], check_head_position) :
          ReturnPostcondition.new(example_definition[:return])
    end
  end

  class FinalBoardPostcondition
    attr_reader :final_board_gbb, :check_head_position

    def initialize(final_board, check_head_position)
      @final_board_gbb = final_board
      @check_head_position = check_head_position
    end
  end

  class ReturnPostcondition
    def initialize(return_value)
      @return_value = return_value
    end
  end
end
