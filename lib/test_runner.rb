require 'mumukit'

class TestRunner
  def gobstones_path
    @config['gobstones_command']
  end

  def post_process_file(file, result, status)
    begin
      [status == :passed ? @output_file.read : result, status]
    ensure
      @output_file.close(true)
    end
  end

  def run_test_command(file)
    @output_file = Tempfile.new(%w(gobstones .html))
    "#{gobstones_path} #{file.path} --size 4 4 --to #{@output_file.path}"
  end
end