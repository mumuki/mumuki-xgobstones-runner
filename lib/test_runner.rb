require 'mumukit'

class TestRunner
  def gobstones_path
    @config['gobstones_command']
  end

  def post_process_file(file, result, status)
    begin
      [status == :passed ? @output_file.read : get_error_message(result), status]
    ensure
      @output_file.close(true)
    end
  end

  def get_error_message(result)
    result.lines.drop(3).take_while { |str| not str.start_with? 'Traceback' }.join.strip
  end

  def run_test_command(file)
    @output_file = Tempfile.new(%w(gobstones .html))
    "#{gobstones_path} #{file.path} --size 4 4 --to #{@output_file.path} 2>&1"
  end
end