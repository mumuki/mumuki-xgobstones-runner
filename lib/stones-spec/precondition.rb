module StonesSpec
  class Precondition
    attr_reader :initial_board_gbb

    def self.from_example(example)
      self.new example.initial_board, example.arguments
    end

    def initialize(initial_board, arguments)
      @initial_board_gbb = initial_board
      @arguments = arguments
    end

    def arguments
      @arguments || []
    end
  end
end
