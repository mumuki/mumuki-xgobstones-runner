require_relative '../with_tempfile'

module Gobstones::Expectations
  class ExpectationsRunner
    include Gobstones::WithTempfile

    def initialize(gobstones_path, source_code)
      @gobstones_path = gobstones_path
      @source_code = source_code
    end

    def run!(expectations)
      ast = get_ast
      expectations.map { |exp| [exp, exp.value_for(ast)] }
    end

    private

    def get_ast
      %x"gbs #{write_tempfile(@source_code, 'gbs').path} --print-ast --no-print-board --no-print-retvals"
    end
  end
end