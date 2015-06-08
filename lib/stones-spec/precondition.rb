module StonesSpec
  class Precondition
    attr_reader :initial_board_gbb

    def initialize(initial_board_gbb, arguments)
      @initial_board_gbb = initial_board_gbb
      @arguments = arguments
    end

    def arguments
      @arguments || []
    end
  end
end
