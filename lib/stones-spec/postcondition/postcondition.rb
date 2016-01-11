require_relative './final_board'
require_relative './return'

module StonesSpec
  module Postcondition
    def self.from(example, check_head_position, show_initial_board)
      example.final_board ?
          FinalBoard.new(example, check_head_position, show_initial_board) :
          Return.new(example)
    end
  end
end
