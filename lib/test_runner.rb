require 'mumukit'
require 'yaml'

require_relative 'gobstones'

class TestRunner
  def gobstones_path
    @config['gobstones_command']
  end

  def post_process_file(file, result, status)
    if status == :passed
      @spec_runner.compute_test_status
    else
      [@spec_runner.get_error_message(result), status]
    end
  ensure
    @spec_runner.stop!
  end

  def run_test_command(test_definition)
    @spec_runner = Gobstones::Spec::Example.new(gobstones_path)
    @spec_runner.start!(test_definition)
  end
end
