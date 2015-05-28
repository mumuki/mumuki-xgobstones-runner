require_relative '../with_tempfile'

module Gobstones::Expectations
  class ExpectationsRunner
    include Gobstones::WithTempfile

    def initialize(gobstones_command, source_code)
      @gobstones_command = gobstones_command
      @source_code = source_code
    end

    def run!(expectations)
      ast = generate_ast!
      expectations.map { |exp| [exp, exp.value_for(ast)] }
    end

    private

    def generate_ast!
      %x"#{@gobstones_command} #{write_tempfile(@source_code, 'gbs').path} --print-ast --no-print-board --no-print-retvals"
    end
  end
end