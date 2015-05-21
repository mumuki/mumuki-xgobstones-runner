require 'mumukit'
require 'yaml'

require_relative 'gobstones'

class TestRunner
  def gobstones_path
    @config['gobstones_command']
  end

  def post_process_file(file, result, status)
    if status == :passed
      @spec_runner.result
    else
      [@spec_runner.parse_error_message(result), status]
    end
  ensure
    @spec_runner.stop!
  end

  def run_test_command(test_definition)
    @spec_runner = Gobstones::Spec::Example.new(gobstones_path)
    @spec_runner.start!(test_definition[:source],
                        test_definition[:examples][:initial_board],
                        test_definition[:examples][:final_board])
  end
end
