module StonesSpec
  class ErrorMessageParser
    def remove_traceback (x)
      x.take_while { |str| not str.start_with? 'Traceback' }
    end

    def remove_line_specification(x)
      x.drop(3)
    end

    def remove_boom_line_specification(x)
      x.take_while { |str| not str.strip.start_with? 'En:' }
    end

    def parse(result)
      remove_boom_line_specification(remove_traceback(remove_line_specification(result.lines))).join.strip
    end
  end
end
