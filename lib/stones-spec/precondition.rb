module StonesSpec
  class Precondition
    attr_reader :initial_board

    def initialize(initial_board, arguments)
      @initial_board = initial_board
      @arguments = arguments
    end

    def arguments
      @arguments || []
    end
  end
end
