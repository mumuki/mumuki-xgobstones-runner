module StonesSpec
  module Postcondition
    class Error
      include StonesSpec::WithGbbHtmlRendering

      attr_reader :example, :error_type

      def initialize(example)
        @example = example
        @error_type = known_error_types[example.error.to_sym]
      end

      def validate(initial_board_gbb, actual_final_board_gbb, result, status)
        if status == :failed
          check_right_error_type initial_board_gbb, result
        else
          boards = [['Tablero inicial', initial_board_gbb], ['Tablero final', actual_final_board_gbb]]
          make_boards_output example.title, boards, :failed, failure_message
        end
      end

      private

      def check_right_error_type(initial_board_gbb, result)
        if error_type_matches? result
          [example.title, :passed, make_error_output(result, initial_board_gbb)]
        else
          [example.title, :failed, "#{invalid_boom_type_message}\n#{make_error_output(result, initial_board_gbb)}"]
        end
      end

      def error_type_matches?(result)
        result.include? error_type[:message]
      end

      def known_error_types
        {
          out_of_board: { message: 'La posición cae afuera del tablero', friendly_message: 'caer fuera del tablero' },
          no_stones: { message: 'No hay bolitas de ese color', friendly_message: 'no haber bolitas' }
        }
      end

      def failure_message
        'Se esperaba que el programa hiciera BOOM pero se obtuvo un tablero final.'
      end

      def invalid_boom_type_message
        "<p>Se esperaba que el programa hiciera BOOM por #{error_type[:friendly_message]}.</p>"
      end
    end
  end
end