module StonesSpec
  module Gobstones
    def self.configure
      @config ||= OpenStruct.new
      yield @config
    end

    def self.config
      @config
    end

    def self.run(source_file, initial_board_file, final_board_file)
      "#{config.gbs_command} #{source_file.path} --from #{initial_board_file.path} --to #{final_board_file.path} --no-print-board --silent"
    end

    def self.parse_error_message(result)
      "<pre>#{ErrorMessageParser.parse result}</pre>"
    end

    def self.runtime_error?(result)
      result.include? 'Error en tiempo de ejecución'
    end

    def self.syntax_error?(result)
      result.include_any? ['Error de sintaxis', 'Error en el programa']
    end

    def self.source_code_extension
      'gbs'
    end

    def self.board_extension
      'gbb'
    end

    def self.ensure_no_syntax_error!(error_message)
      raise SyntaxError, error_message if syntax_error? error_message
    end

    class SyntaxError < Exception
    end

    class AbortedError < Exception
    end
  end
end
