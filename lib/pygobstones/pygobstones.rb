require_relative './with_command_line'
require_relative './error_message_parser'

module StonesSpec
  class PyGobstonesParser
    include WithCommandLine

    def initialize(gbs_command)
      @gbs_command = gbs_command
    end

    def run(source_file, initial_board_file, final_board_file)
      result, status = run_command "#{@gbs_command} #{source_file.path} --from #{initial_board_file.path} --to #{final_board_file.path} --no-print-board --silent 2>&1"

      if status == :failed
        detailed_error = parse_error_message(result)

        detailed_status =
          if syntax_error? result
            :syntax_error
          elsif runtime_error? result
            :runtime_error
          else
            :failed
          end

        { result: detailed_error, status: detailed_status }
      else
        { result: result, status: status }
      end
    end

    private

    def syntax_error?(result)
      result.include? 'Error de sintaxis'
    end

    def runtime_error?(result)
      result.include_any? ['Error en tiempo de ejecución', 'Error en el programa']
    end

    def parse_error_message(result)
      "<pre>#{ErrorMessageParser.parse result}</pre>"
    end
  end
end
