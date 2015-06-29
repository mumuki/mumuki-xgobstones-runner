require 'mumukit'

require_relative 'with_test_parser'

class TestCompiler < Mumukit::Stub
  include WithTestParser

  def create_compilation!(request)
    test = parse_test request
    test[:source] = "#{request[:content]}\n#{request[:extra]}"
    test[:check_head_position] = !!test[:check_head_position]
    test
  end
end
