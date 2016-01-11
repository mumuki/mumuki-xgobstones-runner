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
      "<pre>#{ErrorMessageParser.new.parse(result)}</pre>"
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
  end

  class ErrorMessageParser
    def remove_line_specification(x)
      x.drop_while { |str| !str.include_any? ['cerca de', 'Error de Gobstones'] }
    end

    def remove_boom_line_specification(x)
      x.take_while { |str| not str.strip.start_with? 'En:' }
    end

    def parse(result)
      remove_boom_line_specification(remove_line_specification(result.lines)).join.strip
    end
  end
end
