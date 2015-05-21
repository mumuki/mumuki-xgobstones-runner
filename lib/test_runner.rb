require 'mumukit'
require 'yaml'

require_relative 'gobstones'

class TestRunner < Mumukit::Stub
  include Mumukit::WithCommandLine

  def gobstones_path
    @config['gobstones_command']
  end

  def run_compilation!(test_definition)
    command = create_example_and_get_test_command(test_definition)
    result, status = run_command command
    post_process result, status
  end

  def post_process(result, status)
    if status == :passed
      @example.result
    else
      [@example.parse_error_message(result), status]
    end
  ensure
    @example.stop!
  end

  def create_example_and_get_test_command(test_definition)
    @example = Gobstones::Spec::Example.new(gobstones_path)
    @example.start!(test_definition[:source],
                    test_definition[:examples][:initial_board],
                    test_definition[:examples][:final_board])
  end
end
