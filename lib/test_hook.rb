require 'mumukit'
require 'stones-spec'
require 'yaml'

require_relative 'pygobstones/pygobstones'
require_relative 'with_test_parser'

class GobstonesTestHook < Mumukit::Hook
  include WithTestParser

  def compile(request)
    test = parse_test request
    test[:source] = "#{request[:content]}\n#{request[:extra]}".strip
    test[:check_head_position] = !!test[:check_head_position]
    test
  end

  def run!(test_definition)
    parser = StonesSpec::PyGobstonesParser.new(gobstones_command)
    StonesSpec::Runner.new(parser).run!(test_definition)
  end
end
