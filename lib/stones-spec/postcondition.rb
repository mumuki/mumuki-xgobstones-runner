module StonesSpec
  module Postcondition
    def self.from(example_definition, check_head_position)
      example_definition[:final_board] ?
          FinalBoardPostcondition.new(example_definition[:final_board], check_head_position) :
          ReturnPostcondition.new(example_definition[:return])
    end
  end

  class FinalBoardPostcondition
    include StonesSpec::WithTempfile
    include StonesSpec::WithGbbHtmlRendering

    attr_reader :final_board_gbb, :check_head_position

    def initialize(final_board, check_head_position)
      @final_board_gbb = final_board
      @check_head_position = check_head_position
    end

    def validate(initial_board_file, actual_final_board_gbb, _actual_return)
      actual_final_board = Stones::Gbb.read(actual_final_board_gbb)
      actual_final_board_html = get_html_board(actual_final_board_gbb)

      if matches_with_expected_board? actual_final_board
        passed_result(actual_final_board_html)
      else
        failed_result(initial_board_file, final_board, actual_final_board_html)
      end
    end

    private

    def failed_result(initial_board_file, final_board_gbb, actual_final_board_html)
      initial_board_html = get_html_board initial_board_file.open.read
      expected_board_html = get_html_board final_board_gbb
      output =
"<div>
  #{add_caption initial_board_html, 'Tablero inicial'}
  #{add_caption actual_final_board_html, 'Tablero final obtenido'}
  #{add_caption expected_board_html, 'Tablero final esperado'}
</div>"
      [output, :failed]
    end

    def passed_result(actual_final_board_html)
      ["<div>#{actual_final_board_html}</div>", :passed]
    end


    def add_caption(board_html, caption)
      board_html.sub '<table class="gbs_board">', "<table class=\"gbs_board\">\n<caption>#{caption}</caption>"
    end

    def matches_with_expected_board?(actual_board)
      if check_head_position
        actual_board == final_board
      else
        actual_board.cells_equal? final_board
      end
    end

    def final_board
      Stones::Gbb.read final_board_gbb
    end
  end

  class ReturnPostcondition
    attr_reader :return_value

    def initialize(return_value)
      @return_value = return_value.to_s
    end

    def validate(_initial_board_file, _actual_final_board_gbb, actual_return)
      normalized_actual_return = actual_return.strip

      if normalized_actual_return == return_value
        ['', :passed]
      else
        ["Expected #{return_value} but got #{normalized_actual_return}"]
      end
    end
  end
end
