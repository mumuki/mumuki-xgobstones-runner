module StonesSpec
  module ErrorMessageParser
    def self.parse(result)
      remove_boom_line_specification(remove_line_specification(result.lines)).join.strip
    end

    private

    def self.remove_line_specification(x)
      x.drop_while { |str| !str.include_any? ['cerca de', 'Error de Gobstones'] }
    end

    def self.remove_boom_line_specification(x)
      x.take_while { |str| not str.strip.start_with? 'En:' }
    end
  end
end
