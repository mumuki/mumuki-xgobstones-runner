require 'mumukit'
require 'yaml'

require_relative 'stones-spec'
require_relative 'with_test_parser'

class TestHook < Mumukit::Hook
  include WithTestParser

  def compile(request)
    test = parse_test request
    test[:source] = "#{request[:content]}\n#{request[:extra]}".strip
    test[:check_head_position] = !!test[:check_head_position]
    test
  end

  def run!(test_definition)
    StonesSpec::Gobstones.configure do |config|
      config.gbs_command = gobstones_command
    end

    StonesSpec::Runner.new.run!(test_definition)
  end
end
