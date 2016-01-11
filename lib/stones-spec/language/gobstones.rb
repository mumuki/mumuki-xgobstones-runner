class String
  def start_with_lowercase?
    first_letter = self[0]
    first_letter.downcase == first_letter
  end

  def include_any?(other_strs)
    other_strs.any? { |other| include? other }
  end
end

module StonesSpec::Language
  module Gobstones
    def self.run(source_file, initial_board_file, final_board_file, gobstones_command)
      "#{gobstones_command} #{source_file.path} --from #{initial_board_file.path} --to #{final_board_file.path} --no-print-board --silent"
    end

    def self.parse_error_message(result)
      "<pre>#{ErrorMessageParser.new.parse(result)}</pre>"
    end

    def self.runtime_error?(result)
      result.include? 'Error en tiempo de ejecución'
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
