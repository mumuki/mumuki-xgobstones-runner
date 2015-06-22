module StonesSpec
  class Precondition
    attr_reader :initial_board_gbb

    def initialize(example)
      @initial_board_gbb = example.initial_board
      @arguments = example.arguments
    end

    def arguments
      @arguments || []
    end
  end
end
